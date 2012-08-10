Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2HJBNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:13:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54672 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab2HJBMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:12:55 -0400
X-AuditID: cbfee60d-b7f526d000004e6b-4e-5024601422a7
Date: Fri, 10 Aug 2012 01:12:52 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] PM QoS: Add a metric : Bus Throughput.
To: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120810010647028@myungjoo.ham
Msgkey: 20120810010647028@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120810010647028@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25039060.6131344561170907.JavaMail.weblogic@epml26>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/tmboiCSoBBi+3c1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6My9M/sRXcsam41fORqYFxgnUXIyeHkIC6xKIlJ9m6GDk4JARM
	JM4e1gAJSwiISVy4tx4ozAVUMp9R4v/PSSwgCRYBVYmNk94wg9SzCZhL3J8RBBIWFrCXuPJz
	HSOILSKQJnGt5QEjSC+zQAOTxJL/d9ggdilJrNn3CmwOr4CgxMmZT1gglqlKXFz5jRkiriZx
	r/cXM0RcQmLW9AusEDavxIz2p1D1chLTvq6BqpGWOD9rAyPM0Yu/P4aK80scu72DCeIvXokn
	94Nhxuze/IUNwhaQmHrmIFSrlsSvM6+ZIGw+iTUL37LAjNl1ajkzTO/9LXPBapgFFCWmdD9k
	h7C1JL782MeG7i1eAQeJ1Zv2M05glJuFJDULSfssJO3IahYwsqxiFE0tSC4oTkpPNdYrTswt
	Ls1L10vOz93ECI7yZ7w7GOc2WBxiFOBgVOLhfWCkEiDEmlhWXJl7iFGCg1lJhDflhXKAEG9K
	YmVValF+fFFpTmrxIUZpDhYlcd4vXl/9hQTSE0tSs1NTC1KLYLJMHJxSDYwp16Z2b5lzxjtG
	daVQu86BBRsfpv3ZsN5QJGmpz7ZjojI1UQllWhdkJ6X4aDdkrjyaW9O1Ys38uqWaag19kgtu
	e7WJH2nS/G3i1xFuKKJlK/tQuTtB+W5b/cx1v/9dizLbynwnOiBmp0Wy6rNrZ4OMf/D41zpP
	mfzx7tbTXc1RPK5Mt7Q2TlJiKc5INNRiLipOBACDHfI77gIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7A1DHlO030590

> + Myungjoo Ham,
> 
> It used at devfreq. Mr. Ham can you explain it in detail?
> 
> Thank you,
> Kyungmin Park
> ,
> On 8/9/12, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, August 08, 2012, Jonghwa Lee wrote:
> >> Bus throughput metric is added to PM QoS in order to control the
> >> frequency of memory interfaces and busses with PM QoS.
> >>
> >> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > I said some time ago I didn't want any new global PM QoS classes to be
> > added this way.
> >
> > Can you please post a driver patch using this new thing?
> >
> > Rafael

It'd be too early for V4L2 device driver QoS patches as they are undergoing
major updates and the previous QoS patches over they are now obsolete.

However, I've found that one QoS patch is still intact with the current one.
Here goes the example driver that uses Bus-Throughput for its operation.
(Fortunately, it is not V4L2, but DRM driver)

It is a G2D (2D graphics acceleration) device driver that gets command lists
from userspace and then process them via DMA. Many command lists finish even
before any DVFS mechanism may react while the response time of a command list
is still important for the user processes.

Here we go:

---
diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index d2d88f2..969b2c5 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/pm_qos.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
@@ -135,6 +136,7 @@ struct g2d_data {
 	struct workqueue_struct		*g2d_workq;
 	struct work_struct		runqueue_work;
 	struct exynos_drm_subdrv	subdrv;
+	struct pm_qos_request_list	pm_qos;
 	bool				suspended;
 
 	/* cmdlist */
@@ -314,6 +316,9 @@ static void g2d_dma_start(struct g2d_data *g2d,
 	pm_runtime_get_sync(g2d->dev);
 	clk_enable(g2d->gate_clk);
 
+	/* 416MHz w/ 64b 30% saturating bus */
+	pm_qos_update_request(&g2d->pm_qos, 1000000);
+
 	/* interrupt enable */
 	writel_relaxed(G2D_INTEN_ACF | G2D_INTEN_UCF | G2D_INTEN_GCF,
 			g2d->regs + G2D_INTEN);
@@ -360,6 +365,7 @@ static void g2d_runqueue_worker(struct work_struct *work)
 	struct g2d_data *g2d = container_of(work, struct g2d_data,
 					    runqueue_work);
 
+	pm_qos_update_request(&g2d->pm_qos, 0);
 
 	mutex_lock(&g2d->runqueue_mutex);
 	clk_disable(g2d->gate_clk);
@@ -841,6 +847,8 @@ static int __devinit g2d_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
+	pm_qos_add_request(&g2d->pm_qos, PM_QOS_BUS_DMA_THROUGHPUT, 0);
+
 	dev_info(dev, "The exynos g2d(ver %d.%d) successfully probed\n",
 			G2D_HW_MAJOR_VER, G2D_HW_MINOR_VER);
 
@@ -872,6 +880,7 @@ static int __devexit g2d_remove(struct platform_device *pdev)
 	struct g2d_data *g2d = platform_get_drvdata(pdev);
 
 	cancel_work_sync(&g2d->runqueue_work);
+	pm_qos_remove_request(&g2d->pm_qos);
 	exynos_drm_subdrv_unregister(&g2d->subdrv);
 	free_irq(g2d->irq, g2d);
 


> >
> >
> >> ---
> >>  include/linux/pm_qos.h |    2 ++
> >>  kernel/power/qos.c     |   15 ++++++++++++++-
> >>  2 files changed, 16 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
> >> index 233149c..6db4939 100644
> >> --- a/include/linux/pm_qos.h
> >> +++ b/include/linux/pm_qos.h
> >> @@ -15,6 +15,7 @@ enum {
> >>  	PM_QOS_CPU_DMA_LATENCY,
> >>  	PM_QOS_NETWORK_LATENCY,
> >>  	PM_QOS_NETWORK_THROUGHPUT,
> >> +	PM_QOS_BUS_DMA_THROUGHPUT,
> >>
> >>  	/* insert new class ID */
> >>  	PM_QOS_NUM_CLASSES,
> >> @@ -26,6 +27,7 @@ enum {
> >>  #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
> >>  #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
> >>  #define PM_QOS_DEV_LAT_DEFAULT_VALUE		0
> >> +#define	PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE	0
> >>
> >>  struct pm_qos_request {
> >>  	struct plist_node node;
> >> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
> >> index 6a031e6..75322cc 100644
> >> --- a/kernel/power/qos.c
> >> +++ b/kernel/power/qos.c
> >> @@ -100,12 +100,25 @@ static struct pm_qos_object
> >> network_throughput_pm_qos = {
> >>  	.name = "network_throughput",
> >>  };
> >>
> >> +static BLOCKING_NOTIFIER_HEAD(bus_dma_throughput_notifier);
> >> +static struct pm_qos_constraints bus_dma_tput_constraints = {
> >> +	.list = PLIST_HEAD_INIT(bus_dma_tput_constraints.list),
> >> +	.target_value = PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE,
> >> +	.default_value = PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE,
> >> +	.type = PM_QOS_MAX,
> >> +	.notifiers = &bus_dma_throughput_notifier,
> >> +};
> >> +static struct pm_qos_object bus_dma_throughput_pm_qos = {
> >> +	.constraints = &bus_dma_tput_constraints,
> >> +	.name = "bus_dma_throughput",
> >> +};
> >>
> >>  static struct pm_qos_object *pm_qos_array[] = {
> >>  	&null_pm_qos,
> >>  	&cpu_dma_pm_qos,
> >>  	&network_lat_pm_qos,
> >> -	&network_throughput_pm_qos
> >> +	&network_throughput_pm_qos,
> >> +	&bus_dma_throughput_pm_qos,
> >>  };
> >>
> >>  static ssize_t pm_qos_power_write(struct file *filp, const char __user
> >> *buf,
> >>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
