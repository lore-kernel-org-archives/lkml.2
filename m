Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2JHLHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 07:07:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13454 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2JHLH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 07:07:28 -0400
X-AuditID: cbfee610-b7fc26d00000562c-2b-5072b3ee58e1
Date: Mon, 08 Oct 2012 11:07:26 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4] PM / devfreq: add PM-QoS support
To: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "khilman@ti.com" <khilman@ti.com>,
        "jean.pihet@newoldbits.com" <jean.pihet@newoldbits.com>,
        "mturquette@ti.com" <mturquette@ti.com>,
        =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>,
        "paul@pwsan.com" <paul@pwsan.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121008105848203@myungjoo.ham
Msgkey: 20121008105848203@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121008105848203@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6564542.717721349694445839.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t/t6brvNhcFGKzcIW9xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgymubsZC+4NZ2x4tdnzgbGJ5MZuxg5OYQE1CUWLTnJBmJLCJhI
	HHj4kRXCFpO4cG89UJwLqGY+o8SJQ0uZQRIsAioSs+5sASri4GAT0JOY+TkZJCwsYCGxcd08
	sJkiAlUSnWcfs4L0MgvsYJa4t+AaC8QyJYk1+16B2bwCghInZz5hgVimKnHh3DVmiLiaRMPB
	H8wQcQmJWdMvQB3EKzGj/SlUvZzEtK9roGqkJc7P2sAIc/Ti74+h4vwSx27vYAK5E6T3yf1g
	mDG7N3+B+ldAYuqZg1CtWhLNV1uYIGw+iTUL37LAjNl1ajkzTO/9LXPBapgFFCWmdD9kh7C1
	JL782MeG7i1eAUeJt9PesU9glJuFJDULSfssJO3IahYwsqxiFE0tSC4oTkpPNdMrTswtLs1L
	10vOz93ECI70ZwI7GJc0WBxiFOBgVOLh/ahXFCDEmlhWXJl7iFGCg1lJhDe1HyjEm5JYWZVa
	lB9fVJqTWnyIUZqDRUmct8wjJUBIID2xJDU7NbUgtQgmy8TBKdXAGGC1p36bq73v9KupYe+v
	FIqVV/3tFtWU1shK+l4zjf+SQNeepae2e93KD+DwOn425hbf3dq/jTFzludlrL2eFnYmdlKn
	t0jxGfvpHyKTrv1oX9tovSH9ydR2xs0t3uWeSkWy+6Y/tnoVu/Xgy5zne05I3r3GLDB34ptV
	3pvyv5u78d+3WdFZocRSnJFoqMVcVJwIAPlFW1rwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q98B7dfX030735

Hello,

I didn't include the pm-qos support with the 0-100 (percent) concept
though one might still implement that with per-dev qos support with this
patch.

However, for now, I don't think supporting 0-100 QoS is more appropriate
than global QoS at least for some devices such as memory and networks.
The metrics for them are not too ambigious (kB/s throughput or us latency)
for userspace/drivers while 0-100 might be ambigious for userspace/drivers

For example, if a video decoding device driver wants to get the memory/bus
to work for FHD (e.g., let's say 1Gb/s), at which percent should the memory/bus
work? If it's throughput, it's easy, it should support 1Gb/s or faster.

It appears that 0-100 QoS might be useful only for the cases where
1) the user wants the "full performance" or
2) the user wants to save power: "the least performance".
Normally, the users (Qos Users, either the userspace or other device drivers)
might not be aware of the required performance relative to the max performance.


Because 0-100 QoS surely has its applications and benefits, we should
consider supporting it at the subsystem level; however, I don't think
0-100 QoS concept can replace the global QoS classes.


Cheers!
MyungJoo


> Even if the performance of a device is controlled properly with devfreq,
> sometimes, we still need to get PM-QoS inputs in order to meet the
> required performance.
> 
> In our testbed of Exynos4412, which has on-chip various DMA devices, the
> memory interface and system bus are controlled according to their
> utilization by devfreq. However, in some multimedia applications
> including video-playing with MFC (multi-function codec) H/W and
> photo/video-capturing with FIMC H/W, we have observed issues due to
> insufficient DMA throughput or latency.
> 
> In such applications, there are deadlines: less than 16.6ms with 60Hz.
> With shorter polling intervals (5 ~ 15ms), the frequencies fluctuate
> within a frame and we get missing frames and distorted pictures.
> With longer polling intervals (20 ~ 100ms), the response time is not
> sufficient and we get distorted or broken images. In other words,
> regardless of polling interval, we get poor results with hard-deadline
> H/Ws. They, in fact, have a preset requirement on DMA throughput.
> 
> Thus, we need PM-QoS capabilities in devfreq. (Note that for general
> user applications, devfreq for bus/memory works fine. They are not so
> sensitive to tens of ms in performance increasing responses in general.
> 
> In order to express how to handle QoS requests in devfreq devices,
> the devfreq device drivers only need to express the mappings of
> QoS value and frequency pairs with QoS class along with
> devfreq_add_device() call.
> 
> Tested on Exynos4412 machines with memory/bus frequencies and multimedia
> H/W blocks. (camera, video decoding, and video encoding)
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> ---
> Changes from V3
> - Corrected and added comments
> - Code Clean
> - Merged per-dev qos patch and global qos patch
> 
> Changed from V2-resend
> - Removed dependencies on global pm-qos class definitions
> - Revised data structure handling pm-qos (being ready for dev-pm-qos)
> 
> Changes from V2
> - Rebased
> 
> Changes from V1
> - Error handling at devfreq_add_device()
> - Handling pm_qos_max information
> - Styly update
> ---
>  drivers/devfreq/devfreq.c |  137 ++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/devfreq.h   |   41 +++++++++++++
>  2 files changed, 177 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 00e326c..d0cb33b 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -25,6 +25,7 @@
>  #include <linux/list.h>
>  #include <linux/printk.h>
>  #include <linux/hrtimer.h>
> +#include <linux/pm_qos.h>
>  #include "governor.h"
>  
>  static struct class *devfreq_class;
> @@ -136,8 +137,13 @@ int update_devfreq(struct devfreq *devfreq)
>  	 * List from the highest proiority
>  	 * max_freq (probably called by thermal when it's too hot)
>  	 * min_freq
> +	 * qos_min_freq
>  	 */
>  
> +	if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq) {
> +		freq = devfreq->qos_min_freq;
> +		flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
> +	}
>  	if (devfreq->min_freq && freq < devfreq->min_freq) {
>  		freq = devfreq->min_freq;
>  		flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
> @@ -183,6 +189,56 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
>  }
>  
>  /**
> + * devfreq_qos_notifier_call() - Handle QoS requests (updates)
> + *
> + * @nb		the notifier_block (supposed to be devfreq->qos_nb)
> + * @value	the QoS value
> + * @devp	not used
> + */
> +static int devfreq_qos_notifier_call(struct notifier_block *nb,
> +				     unsigned long value, void *devp)
> +{
> +	struct devfreq *devfreq = container_of(nb, struct devfreq, qos_nb);
> +	int ret;
> +	int i;
> +	s32 default_value = PM_QOS_DEFAULT_VALUE;
> +	struct devfreq_pm_qos_table *qos_list = devfreq->profile->qos_list;
> +	bool qos_use_max = devfreq->profile->qos_use_max;
> +
> +	if (!qos_list)
> +		return NOTIFY_DONE;
> +
> +	mutex_lock(&devfreq->lock);
> +
> +	if (value == default_value) {
> +		devfreq->qos_min_freq = 0;
> +		goto update;
> +	}
> +
> +	for (i = 0; qos_list[i].freq; i++) {
> +		/* QoS Met */
> +		if (qos_use_max) {
> +			if (qos_list[i].qos_value < value)
> +				continue;
> +		} else {
> +			if (qos_list[i].qos_value > value)
> +				continue;
> +		}
> +		devfreq->qos_min_freq = qos_list[i].freq;
> +		goto update;
> +	}
> +
> +	/* Use the highest QoS freq */
> +	devfreq->qos_min_freq = qos_list[i - 1].freq;
> +
> +update:
> +	ret = update_devfreq(devfreq);
> +	mutex_unlock(&devfreq->lock);
> +
> +	return ret;
> +}
> +
> +/**
>   * _remove_devfreq() - Remove devfreq from the device.
>   * @devfreq:	the devfreq struct
>   * @skip:	skip calling device_unregister().
> @@ -219,6 +275,13 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
>  
>  	devfreq->being_removed = true;
>  
> +	if (devfreq->profile->enable_dev_pm_qos)
> +		dev_pm_qos_remove_notifier(devfreq->dev.parent,
> +					   &devfreq->qos_nb);
> +	if (devfreq->profile->qos_type)
> +		pm_qos_remove_notifier(devfreq->profile->qos_type,
> +				       &devfreq->qos_nb);
> +
>  	if (devfreq->profile->exit)
>  		devfreq->profile->exit(devfreq->dev.parent);
>  
> @@ -376,6 +439,50 @@ static void devfreq_monitor(struct work_struct *work)
>  	}
>  }
>  
> +static int devfreq_qos_sanity_check(struct device *dev,
> +				    struct devfreq_dev_profile *profile)
> +{
> +	int i;
> +
> +	if (!profile->qos_type && !profile->enable_dev_pm_qos ||
> +				  !profile->qos_list) {
> +		dev_WARN(dev, "QoS requirement partially omitted.");
> +		return -EINVAL;
> +	}
> +
> +	if (!profile->qos_list[0].freq) {
> +		dev_WARN(dev, "The first QoS requirement is also the last requirement.");
> +		return -EINVAL;
> +	}
> +
> +	for (i = 1; profile->qos_list[i].freq; i++) {
> +		if (profile->qos_list[i].freq <=
> +		    profile->qos_list[i - 1].freq) {
> +			dev_WARN(dev, "qos_list[].freq not sorted in the ascending order. ([%d]=%lu, [%d]=%lu)\n",
> +				 i - 1, profile->qos_list[i - 1].freq,
> +				 i, profile->qos_list[i].freq);
> +			return -EINVAL;
> +
> +		if (profile->qos_use_max) {
> +			/* Throughput-like QoS type */
> +			if (profile->qos_list[i - 1].qos_value >
> +			    profile->qos_list[i].qos_value) {
> +				dev_WARN(dev, "qos_list[].qos_value needs to be sorted in the ascending order if qos_use_max is true.");
> +				return -EINVAL;
> +			}
> +		} else {
> +			/* Latency-like QoS type */
> +			if (profile->qos_list[i - 1].qos_value <
> +			    profile->qos_list[i].qos_value) {
> +				dev_WARN(dev, "qos_list[].qos_value needs to be sorted in the descending order if qos_use_max is false.");
> +				return -EINVAL;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * devfreq_add_device() - Add devfreq feature to the device
>   * @dev:	the device to add devfreq feature.
> @@ -429,6 +536,21 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  	devfreq->next_polling = devfreq->polling_jiffies
>  			      = msecs_to_jiffies(devfreq->profile->polling_ms);
>  	devfreq->nb.notifier_call = devfreq_notifier_call;
> +	devfreq->qos_nb.notifier_call = devfreq_qos_notifier_call;
> +
> +	/* Check the sanity of qos_list/qos_type */
> +	if (profile->qos_type || profile->enable_dev_pm_qos ||
> +	    profile->qos_list) {
> +		err = devfreq_qos_sanity_check(dev, profile);
> +		if (err)
> +			goto err_dev;
> +
> +		if (profile->qos_type)
> +			pm_qos_add_notifier(profile->qos_type,
> +					    &devfreq->qos_nb);
> +		if (profile->enable_dev_pm_qos)
> +			dev_pm_qos_add_notifier(dev, &devfreq->qos_nb);
> +	}
>  
>  	devfreq->trans_table =	devm_kzalloc(dev, sizeof(unsigned int) *
>  						devfreq->profile->max_state *
> @@ -443,7 +565,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  	err = device_register(&devfreq->dev);
>  	if (err) {
>  		put_device(&devfreq->dev);
> -		goto err_dev;
> +		goto err_qos_add;
>  	}
>  
>  	if (governor->init)
> @@ -471,6 +593,11 @@ out:
>  
>  err_init:
>  	device_unregister(&devfreq->dev);
> +err_qos_add:
> +	if (profile->enable_dev_pm_qos)
> +		dev_pm_qos_remove_notifier(dev, &devfreq->qos_nb);
> +	if (profile->qos_type)
> +		pm_qos_remove_notifier(profile->qos_type, &devfreq->qos_nb);
>  err_dev:
>  	mutex_unlock(&devfreq->lock);
>  	kfree(devfreq);
> @@ -568,6 +695,13 @@ static ssize_t show_central_polling(struct device *dev,
>  		       !to_devfreq(dev)->governor->no_central_polling);
>  }
>  
> +static ssize_t show_qos_min_freq(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	return sprintf(buf, "%lu\n", to_devfreq(dev)->qos_min_freq);
> +}
> +
>  static ssize_t store_min_freq(struct device *dev, struct device_attribute *attr,
>  			      const char *buf, size_t count)
>  {
> @@ -685,6 +819,7 @@ static struct device_attribute devfreq_attrs[] = {
>  	       store_polling_interval),
>  	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
>  	__ATTR(max_freq, S_IRUGO | S_IWUSR, show_max_freq, store_max_freq),
> +	__ATTR(qos_min_freq, S_IRUGO, show_qos_min_freq, NULL),
>  	__ATTR(trans_stat, S_IRUGO, show_trans_table, NULL),
>  	{ },
>  };
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 30dc0d8..2488343 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -53,6 +53,21 @@ struct devfreq_dev_status {
>  #define DEVFREQ_FLAG_LEAST_UPPER_BOUND		0x1
>  
>  /**
> + * struct devfreq_pm_qos_table - An PM QoS requiement entry for devfreq dev.
> + * @freq		Lowest frequency to meet the QoS requirement
> + *			represented by qos_value. If freq=0, it means that
> + *			this element is the last in the array.
> + * @qos_value		The qos value defined in pm_qos.h
> + *
> + * Note that the array of devfreq_pm_qos_table should be sorted by freq
> + * in the ascending order except for the last element, which should be 0.
> + */
> +struct devfreq_pm_qos_table {
> +	unsigned long freq; /* 0 if this is the last element */
> +	s32 qos_value;
> +};
> +
> +/**
>   * struct devfreq_dev_profile - Devfreq's user device profile
>   * @initial_freq	The operating frequency when devfreq_add_device() is
>   *			called.
> @@ -71,11 +86,33 @@ struct devfreq_dev_status {
>   *			from devfreq_remove_device() call. If the user
>   *			has registered devfreq->nb at a notifier-head,
>   *			this is the time to unregister it.
> + * @qos_type		QoS Type (defined in pm_qos.h)
> + *			0 (PM_QOS_RESERVED) if not used.
> + * @qos_use_max		True: the highest QoS value is used (for QoS
> + *			requirement of throughput, bandwidth, or similar)
> + *			False: the lowest QoS value is used (for QoS
> + *			requirement of latency, delay, or similar)
> + * @enable_dev_pm_qos	dev_pm_qos is enabled using the qos_list.
> + * @qos_list		Array of QoS requirements ending with .freq = 0
> + *			NULL if not used. It should be either NULL or
> + *			have a length > 1 with a first element effective.
> + *			This QoS specification is shared by the global
> + *			PM QoS (qos_type) and the per-dev PM QoS
> + *			(enable_dev_pm_qos).
> + *
> + * Note that the array of qos_list should be sorted by freq
> + * in the ascending order.
>   */
>  struct devfreq_dev_profile {
>  	unsigned long initial_freq;
>  	unsigned int polling_ms;
>  
> +	/* Optional QoS Handling Specification */
> +	int qos_type; /* 0: No global PM-QoS support */
> +	bool qos_use_max; /* true if "bandwidth"/"throughput"-like values */
> +	bool enable_dev_pm_qos; /* False: No per-dev PM-QoS support */
> +	struct devfreq_pm_qos_table *qos_list; /* QoS handling specification */
> +
>  	int (*target)(struct device *dev, unsigned long *freq, u32 flags);
>  	int (*get_dev_status)(struct device *dev,
>  			      struct devfreq_dev_status *stat);
> @@ -139,6 +176,8 @@ struct devfreq_governor {
>   *			order to prevent trying to remove the object multiple times.
>   * @min_freq	Limit minimum frequency requested by user (0: none)
>   * @max_freq	Limit maximum frequency requested by user (0: none)
> + * @qos_nb	notifier block used to notify pm qos requests
> + * @qos_min_freq	Limit minimum frequency requested by QoS
>   *
>   * This structure stores the devfreq information for a give device.
>   *
> @@ -167,6 +206,8 @@ struct devfreq {
>  
>  	unsigned long min_freq;
>  	unsigned long max_freq;
> +	struct notifier_block qos_nb;
> +	unsigned long qos_min_freq;
>  
>  	/* information for device freqeuncy transition */
>  	unsigned int total_trans;
> -- 
> 1.7.4.1
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
