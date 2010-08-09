Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0HIRIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:08:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:13031 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab0HIRIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:08:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,344,1278313200"; 
   d="scan'208";a="594369690"
Subject: Re: [PATCH wq#for-linus] workqueue: workqueue_cpu_callback()
 should be cpu_notifier not hotcpu_notifier
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>, walt <w41ter@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4C5FCC14.6030901@gmail.com>
References: <i3n3dh$t48$1@dough.gmane.org>
	 <20100809063742.GA1632@arch.tripp.de>
	 <20100809083053.GB2169@osiris.boeblingen.de.ibm.com>
	 <20100809083451.GC2169@osiris.boeblingen.de.ibm.com>
	 <4C5FC49B.9040208@kernel.org>  <4C5FCC14.6030901@gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 09 Aug 2010 10:07:54 -0700
Message-Id: <1281373674.2734.7.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 02:36 -0700, Tejun Heo wrote:
> Commit 6ee0578b (workqueue: mark init_workqueues as early_initcall)
> made workqueue SMP initialization depend on workqueue_cpu_callback(),
> which however was registered as hotcpu_notifier() and didn't get
> called if CONFIG_HOTPLUG_CPU is not set.  This made gcwqs on non-boot
> CPUs not create their initial workers leading to boot failures.  Fix
> it by making it a cpu_notifier.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-and-bisected-by: walt <w41ter@gmail.com>
> ---
> So, something like this.  Can you please verify the fix?
> 
> Thanks.
> 
>  kernel/workqueue.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index da6c482..2994a0e 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3527,7 +3527,7 @@ static int __init init_workqueues(void)
>  	unsigned int cpu;
>  	int i;
> 
> -	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
> +	cpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
> 
>  	/* initialize gcwqs */
>  	for_each_gcwq_cpu(cpu) {

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

