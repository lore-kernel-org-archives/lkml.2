Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072Ab2KWJzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:55:43 -0500
Received: from antcom.de ([188.40.178.216]:36510 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161025Ab2KWJzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:55:41 -0500
Message-ID: <50AF4819.6020509@antcom.de>
Date: Fri, 23 Nov 2012 10:55:37 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Alban Bedel <alban.bedel@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 2/3] pwm: lpc32xx - Properly disable the clock on device
 remove
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de> <1352894295-14339-3-git-send-email-alban.bedel@avionic-design.de> <CAAAP30GTuCB6FCvM9v-ju8y5b+UhQdDnEnHALtewfOzWnD1v=A@mail.gmail.com>
In-Reply-To: <CAAAP30GTuCB6FCvM9v-ju8y5b+UhQdDnEnHALtewfOzWnD1v=A@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 11:31 PM, Alexandre Pereira da Silva wrote:
> Em 14/11/2012 09:58, "Alban Bedel" <alban.bedel@avionic-design.de> escreveu:
>>
>> A single clock is used for all PWMs meaning the clock ref count might
>> be between 0 and N when remove() is called. Instead of a single
>> clk_disable() call pwm_disable() on each PWM, that ensure that
>> clk_disable() is called for each PWM that were still enabled.
>>
>> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> 
> Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Some style fixes necessary below (Thierry will take care of it), otherwise:

Acked-by: Roland Stigge <stigge@antcom.de>

> 
>> ---
>>  drivers/pwm/pwm-lpc32xx.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
>> index 03ec3ff..f45ce2c 100644
>> --- a/drivers/pwm/pwm-lpc32xx.c
>> +++ b/drivers/pwm/pwm-lpc32xx.c
>> @@ -136,8 +136,11 @@ static int lpc32xx_pwm_probe(struct platform_device
> *pdev)
>>  static int __devexit lpc32xx_pwm_remove(struct platform_device *pdev)
>>  {
>>         struct lpc32xx_pwm_chip *lpc32xx = platform_get_drvdata(pdev);
>> +       int i;
>> +
>> +       for (i = 0 ; i < lpc32xx->chip.npwm ; i += 1)
>> +               pwm_disable(&lpc32xx->chip.pwms[i]);
>>
>> -       clk_disable(lpc32xx->clk);
>>         return pwmchip_remove(&lpc32xx->chip);
>>  }
>>
>> --
>> 1.7.0.4
>>
> 

