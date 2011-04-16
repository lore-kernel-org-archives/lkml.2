Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1DPRiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 13:38:54 -0400
Received: from mail.perches.com ([173.55.12.10]:4745 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1DPRiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 13:38:50 -0400
Subject: Re: [PATCHv1 3/11] RTC: RTC module of DA9052 PMIC driver
From: Joe Perches <joe@perches.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B6777D5@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B6777D5@KCINPUNHJCMS01.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Apr 2011 10:38:48 -0700
Message-ID: <1302975528.27935.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 16:32 +0530, Ashish Jangam wrote:
> RTC Driver for Dialog Semiconductor DA9052 PMICs.

Just some comments on messaging.

Because you have __func__ defined in rtc_err, you don't
need to repeat it in the message format.

> diff -Naur linux-2.6.38.2/drivers/rtc/rtc-da9052.c wrk_linux-2.6.38.2/drivers/rtc/rtc-da9052.c
[]
> +#define rtc_err(da9052, fmt, ...) \
> +		dev_err(da9052->dev, "%s: " fmt, __func__, ##__VA_ARGS__)
[]
> +static int da9052_rtc_enable_alarm(struct da9052 *da9052, bool enable)
> +{
[]
> +			rtc_err(da9052, "da9052_rtc_enable_alarm write error %d\n",
> +					ret);

			rtc_err(da9052, "write error: %d\n", ret);

> +static irqreturn_t da9052_rtc_irq(int irq, void *data)
> +{
[]
> +	ret = da9052_reg_read(rtc->da9052, DA9052_ALARM_MI_REG);
> +	if (ret < 0) {
> +		rtc_err(rtc->da9052, "da9052_rtc_notifier read error %d\n",
> +					ret);

Error message doesn't make sense to me.  Maybe:
		rtc_err(rtc->da9052, "read error: %d\n", ret);

[]
> +static int da9052_rtc_read_time
> +			(struct device *dev, struct rtc_time *rtc_tm)
> +{
[]
> +	ret = rtc_valid_tm(rtc_tm);
> +	if (ret != 0) {
> +		rtc_err(rtc->da9052, "da9052_rtc_read_time valid time failed %d\n",
> +					ret);

		rtc_err(rtc->da9052, "rtc_valid_tm failed: %d\n", ret);

> +static int __devinit da9052_rtc_probe(struct platform_device *pdev)
> +{
[]
> +	ret = request_threaded_irq(rtc->da9052->irq_base + rtc->irq,
> +				NULL, da9052_rtc_irq,
> +				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				"ALM", rtc);
> +	if (ret != 0) {
> +		rtc_err(rtc->da9052, "DA9052 RTC failed irq registration: %d\n",
> +					ret);

		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);


