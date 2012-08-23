Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab2HWHV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:21:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34054 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213Ab2HWHVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:21:22 -0400
X-AuditID: cbfee612-b7f1f6d000006c4c-93-5035d9ef0561
Date: Thu, 23 Aug 2012 07:21:19 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] PM: devfreq: add freq table and available_freqs
To: "XiaoguangChen<chenxg"@marvell.com
Cc: linux-kernel@vger.kernel.org
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120823072004601@myungjoo.ham
Msgkey: 20120823072004601@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120823072004601@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <26135480.308741345706478941.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/tGbrvb5oGGJw4p2JxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyLlx4zlywSbeiZ3cXcwPjDJ0uRk4OIQF1iUVLTrKB2BICJhLf
	L25ngbDFJC7cWw8U5wKqmc8oce/6erAiFgFVie1LXwEVcXCwCehJzPycDBIWFvCQmL/sMFiv
	iICmxPvFH1hBbGag8vstG5khdilJrNn3CqyGV0BQ4uTMJ1C7VCXOPvvPCjKSV0BNYsEsR4iw
	hMSs6RdYIWxeiRntT6HK5SSmfV3DDGFLS5yftYER5uTF3x9Dxfkljt3ewQQyEqT3yf1gmDG7
	N3+B+lZAYuqZg1CtWhJN+49Cxfkk1ix8ywIzZtep5cwwvfe3zGWC+EpRYkr3Q3YIW0viy499
	bOi+4hVwkvh29QnLBEa5WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9FQLveLE3OLSvHS95Pzc
	TYzgGH8mtINxWYPFIUYBDkYlHt6MWNMAIdbEsuLK3EOMEhzMSiK84fOAQrwpiZVVqUX58UWl
	OanFhxilOViUxHnnvPjiLySQnliSmp2aWpBaBJNl4uCUamCsUPzSUaPA8/OB+v9WSXWm601G
	vBoiNQxMJZZvfr0xk3w1eX7Q+57Twg9n33Y/YiU2ueP2lR3BU/4qMc70uHKs18n+G//cM7OS
	Ir8yl7Isij291HLpzq5pmsFfVpw7svKq+pwDgiIGAjV7RPj7iw5oMQnW5fTVHN/MofdK/fFU
	6f77lSGCCWJKLMUZiYZazEXFiQDhhnnJ7QIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7N7LUuk029007

> Devfreq framework don't have a frequency table, add it
> for easy use.
> 
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>

As we are going to have transition statistics (similar with trans_table
and time_in_state of CPUfreq), we are going to have a data structure
that your suggested code may use.

Could you please rephrase your code to be based on Jonghwa's patch?
"devfreq: Add sysfs node for representing frequency transition information."

Cheers!
MyungJoo

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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
