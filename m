Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2ESFpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 01:45:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2ESFpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 01:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120519054403.A0A233E046E@localhost>
References: <1337240103-4756-1-git-send-email-shawn.guo@linaro.org>
 <1337240103-4756-2-git-send-email-shawn.guo@linaro.org> <20120519054403.A0A233E046E@localhost>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 May 2012 23:45:11 -0600
X-Google-Sender-Auth: _lRXJ6BGKwXNPMF_V45TMgsL_O8
Message-ID: <CACxGe6tbK3R9FgsjSbDQEtFavt9_3NWR3=kBgZtK3av3X41kaQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio/generic: initialize basic_mmio_gpio shadow
 variables properly
To: Shawn Guo <shawn.guo@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>,
        Ryan Mallon <ryan@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Hans J. Koch" <hjk@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:44 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Thu, 17 May 2012 15:35:02 +0800, Shawn Guo <shawn.guo@linaro.org> wrote:
>> It fixes the issue in gpio-generic that commit fb14921 (gpio/mxc: add
>> missing initialization of basic_mmio_gpio shadow variables) manged to
>> fix in gpio-mxc driver, so that other platform specific drivers do not
>> suffer from the same problem over and over again.
>>
>> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>> ---
>>  drivers/gpio/gpio-generic.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
>> index e38dd0c..cfc9439 100644
>> --- a/drivers/gpio/gpio-generic.c
>> +++ b/drivers/gpio/gpio-generic.c
>> @@ -394,6 +394,10 @@ int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
>>               return ret;
>>
>>       bgc->data = bgc->read_reg(bgc->reg_dat);
>> +     if (bgc->gc.set == bgpio_set_set)
>> +             bgc->data = bgc->read_reg(bgc->reg_set);
>> +     if (bgc->reg_dir)
>> +             bgc->dir = bgc->read_reg(bgc->reg_dir);
>
> This assumes that the set and dir registers are actually readable
> which isn't the case on some hardware.  There needs to be a mechanism
> for drivers using bgpio_init to control how data & dir are initialized
> (possibly with some flags; maybe replace the big_endian arg with a
> flags arg).

If you can turn it around quickly, I'll still try to get it in for v3.5

g.
