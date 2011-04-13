Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1DMACT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:02:19 -0400
Received: from mail.perches.com ([173.55.12.10]:4665 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab1DMACS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:02:18 -0400
Subject: Re: [PATCHv1 3/11] RTC: RTC module of DA9052 PMIC driver
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ashish Jangam <Ashish.Jangam@kpitcummins.com>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110412163743.1d7353c4.akpm@linux-foundation.org>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC209@KCINPUNHJCMS01.kpit.com>
	 <20110412163743.1d7353c4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 17:02:16 -0700
Message-ID: <1302652936.1664.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 16:37 -0700, Andrew Morton wrote:
> On Wed, 6 Apr 2011 18:47:29 +0530
> Ashish Jangam <Ashish.Jangam@kpitcummins.com> wrote:
> Please feed all the patches through scritps/checkpatch.pl if you haven't
> already done so, to clean up lots of trivial errors.
> For example, "MFD: MFD module of DA9052 PMIC driver":
> 	total: 449 errors, 832 warnings, 2326 lines checked

And a couple of more comments...

> > +static int da9052_rtc_enable_alarm(struct da9052 *da9052, unsigned char flag)
[]
> > +		if (ret != 0)
> > +			dev_err(da9052->dev, "da9052_rtc_enable_alarm -> \
> > +					da9052_clear_bits error %d\n", ret);
[]
> > +	ret = da9052_reg_read(rtc->da9052, DA9052_ALARM_MI_REG);
> > +	if (ret < 0) {
> > +		dev_err(rtc->da9052->dev, "da9052_rtc_notifier -> \
> > +					da9052_reg_read error %d\n", ret);

Line continuations in the middle a format string are very
error prone to whitespace errors, just like these introduce
bad whitespace after the ->.

These are better as:

		dev_err(rtc->da9052->dev, "%s: da9052_reg_read error: %d\n",
			__func__, ret);

Or maybe use some new macro/function(s) like

#define rtc_err(rtc, fmt, ...)	\
	dev_err((rtc)->da9052->dev, "%s: " fmt, __func__, ##__VA_ARGS__)

so these can be:

		rtc_err(rtc, "da9052_reg_read error: %d\n, ret);


