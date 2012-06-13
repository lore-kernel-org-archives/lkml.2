Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2FMExu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:53:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10890 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FMExs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:53:48 -0400
X-AuditID: cbfee60f-b7f406d00000703d-63-4fd81cda04cf
Date: Wed, 13 Jun 2012 04:53:46 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs
To: Xiaoguang Chen <chenxg@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        linux-pm@lists.linux-foundation.org
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120613044913757@myungjoo.ham
Msgkey: 20120613044913757@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120613044913757@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <16928680.915361339563225913.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t/tGbq3ZG74G0x7bWhxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgybv0/w1TwRafifucW5gbGO9pdjJwcQgLqEouWnGQDsSUETCTu
	NVyEssUkLtxbD2RzAdXMZ5Q4+PscO0iCRUBVYv6cyYxdjBwcbAJ6EjM/J4OEhQU8JOYvO8wC
	YosIZEn0L/oBVs4skCsx8fZhZohdShJr9r0Cq+EVEJQ4OfMJC8QuoJH/H7NCxNUk/l1ezAgR
	l5CYNf0CK4TNKzGj/SlUvZzEtK9rmCFsaYnzszYwwty8+PtjqDi/xLHbO5hAzgTpfXI/GGbM
	7s1foF4UkJh65iBUq5bEhflzmCBsPok1C9+ywIzZdWo5M8QrihJTuh9CvaUl8eXHPjZ0r/AK
	OEm0tDczT2CUnYUkNQtJ+ywk7chqFjCyrGIUTS1ILihOSk811StOzC0uzUvXS87P3cQIjuZn
	/DsYFzVYHGIU4GBU4uFdKHnDX4g1say4MvcQowQHs5IIb/HW6/5CvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeXutL/gLCaQnlqRmp6YWpBbBZJk4OKUaGIOXlE122d+9LN7g3cHEW35dOz/m782p
	XXVlvqvzfPtAXj1B/VUrGrwem1ndvL9lVcvTIAaLgO2LrHh37/wZxFb6K6xFtP/wpW9vWB+K
	K4W9nT3zhdT1zKJ7SbYNj3+1TLuwI+3/gpTeNH0P39UX9lv02a36Frimeyaf36ldV504xK48
	m2/065YSS3FGoqEWc1FxIgC/HPsc4gIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5D4siIA022376

> Devfreq framework don't have a frequency table, add it
> for easy use.
> 
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>

If you need a predefined data structure to support frequency table,
you can simply use OPP, which has helper functions implemented in
devfreq subsystem. Is there any reason not to use OPP and to implement
another data structure to store a frequency table attached to a device?


Cheers!
MyungJoo.

> ---
>  drivers/devfreq/devfreq.c |   26 ++++++++++++++++++++++++++
>  include/linux/devfreq.h   |   12 ++++++++++++
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 70c31d4..2144200 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -460,6 +460,17 @@ int devfreq_remove_device(struct devfreq *devfreq)
>  	return 0;
>  }
>  
> +/*
> + * devfreq_set_freq_table()- Set frequency table for devfreq
> + * @devfreq	The devfreq instance
> + * @table	The frequency table that device supports
> + */
> +void devfreq_set_freq_table(struct devfreq *devfreq,
> +			    struct devfreq_frequency_table *table)
> +{
> +	devfreq->freq_table = table;
> +}
> +
>  static ssize_t show_governor(struct device *dev,
>  			     struct device_attribute *attr, char *buf)
>  {
> @@ -472,6 +483,20 @@ static ssize_t show_freq(struct device *dev,
>  	return sprintf(buf, "%lu\n", to_devfreq(dev)->previous_freq);
>  }
>  
> +static ssize_t show_avail_freq(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	int len = 0, i;
> +	struct devfreq *devfreq = to_devfreq(dev);
> +	if (devfreq->freq_table)
> +		for (i = 0; devfreq->freq_table[i].frequency != DEVFREQ_TABLE_END; i++)
> +			len += sprintf(buf + len, "%lu\n",
> +				       devfreq->freq_table[i].frequency);
> +	if (len == 0)
> +		len += sprintf(buf + len, "No frequency table is provided\n");
> +	return len;
> +}
> +
>  static ssize_t show_polling_interval(struct device *dev,
>  				     struct device_attribute *attr, char *buf)
>  {
> @@ -595,6 +620,7 @@ static struct device_attribute devfreq_attrs[] = {
>  	       store_polling_interval),
>  	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
>  	__ATTR(max_freq, S_IRUGO | S_IWUSR, show_max_freq, store_max_freq),
> +	__ATTR(available_freqs, S_IRUGO, show_avail_freq, NULL),
>  	{ },
>  };
>  
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 281c72a..e5e4036 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -52,6 +52,14 @@ struct devfreq_dev_status {
>   */
>  #define DEVFREQ_FLAG_LEAST_UPPER_BOUND		0x1
>  
> +#define DEVFREQ_ENTRY_INVALID (~0)
> +#define DEVFREQ_TABLE_END     (~1)
> +
> +struct devfreq_frequency_table {
> +	unsigned int index;
> +	unsigned long frequency;
> +};
> +
>  /**
>   * struct devfreq_dev_profile - Devfreq's user device profile
>   * @initial_freq	The operating frequency when devfreq_add_device() is
> @@ -130,6 +138,7 @@ struct devfreq_governor {
>   *			"devfreq_monitor" executions to reevaluate
>   *			frequency/voltage of the device. Set by
>   *			profile's polling_ms interval.
> + * @freq_table	The frequency table that device supports
>   * @data	Private data of the governor. The devfreq framework does not
>   *		touch this.
>   * @being_removed	a flag to mark that this object is being removed in
> @@ -157,6 +166,7 @@ struct devfreq {
>  	unsigned long polling_jiffies;
>  	unsigned long previous_freq;
>  	unsigned int next_polling;
> +	struct devfreq_frequency_table *freq_table;
>  
>  	void *data; /* private data for governors */
>  
> @@ -180,6 +190,8 @@ extern int devfreq_register_opp_notifier(struct device *dev,
>  					 struct devfreq *devfreq);
>  extern int devfreq_unregister_opp_notifier(struct device *dev,
>  					   struct devfreq *devfreq);
> +extern void devfreq_set_freq_table(struct devfreq *devfreq,
> +				   struct devfreq_frequency_table *table);
>  
>  #ifdef CONFIG_DEVFREQ_GOV_POWERSAVE
>  extern const struct devfreq_governor devfreq_powersave;
> -- 
> 1.7.0.4
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
