Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0IOS0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:26:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54264 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab0IOS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:26:11 -0400
Message-ID: <4C910FA5.8020507@oracle.com>
Date: Wed, 15 Sep 2010 11:25:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Arun MURTHY <arun.murthy@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500: update kconfig for ab8500 core driver
References: <1284549823-6246-1-git-send-email-arun.murthy@stericsson.com> <20100915082014.99d702e4.randy.dunlap@oracle.com> <F45880696056844FA6A73F415B568C69532D96AA36@EXDCVYMBSTM006.EQ1STM.local> <20100915104105.e77dfe8c.randy.dunlap@oracle.com> <20100915182145.GF2597@sortiz-mobl>
In-Reply-To: <20100915182145.GF2597@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/10 11:21, Samuel Ortiz wrote:
> Hi Randy,
> 
> On Wed, Sep 15, 2010 at 10:41:05AM -0700, Randy Dunlap wrote:
>> I don't know what the __crc_* symbols are (I can't find them anywhere).
>>
>> The other functions (pwm_config, pwm_free, pwm_request, pwm_disable,
>> pwm_enable) exist in multiple places.  This is not good.
>> They are very generically named.  The instances of these that are
>> provided by platform code are OK (these):
>>
>> ./include/linux/pwm.h:19:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
>> ./arch/arm/plat-pxa/pwm.c:64:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>> ./arch/arm/plat-pxa/pwm.c:101:EXPORT_SYMBOL(pwm_config);
>> ./arch/arm/plat-samsung/pwm.c:194:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>> ./arch/arm/plat-samsung/pwm.c:281:EXPORT_SYMBOL(pwm_config);
>> ./arch/arm/plat-mxc/pwm.c:55:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>> ./arch/arm/plat-mxc/pwm.c:114:EXPORT_SYMBOL(pwm_config);
>> ./arch/mips/jz4740/pwm.c:94:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>>
>> but the instances of these that are defined in
>> drivers/mfd/twl6030-pwm.c should not be named so generically.
>>
>> Changing (Fixing) the function names in twl6030-pwm.c should fix the build problem
>> that you reported, I think.  
> The pwm "API" relies on someone providing the pwm_* symbols, and then you have
> leds_pwm or backlight_pwm calling those symbols out of the blue.
> If we change the twl6030-pwm.c function names, no pwm users (backlight, led or
> input) will actually be able to use the twl6030 PWM driver.
> The pwm API is very poorly designed in my opinion and should provide a way for
> pwm drivers to register against it. pwm users will then call into the pwm
> framework who would select which driver to use.

So twl6030-pwm is a provider, just like some of the arch/ providers?
OK, I couldn't see that.

>> And it will still allow the ab8500 driver to be
>> built on other platforms, which is what we prefer when that is possible.
> I agree with that, but couldnt see any other fix with the current pwm
> situation.

OK, thanks.  Do whatever you have to do.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
