Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0IOSV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:21:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:22463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab0IOSVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,372,1280732400"; 
   d="scan'208";a="607237582"
Date: Wed, 15 Sep 2010 20:21:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Arun MURTHY <arun.murthy@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500: update kconfig for ab8500 core driver
Message-ID: <20100915182145.GF2597@sortiz-mobl>
References: <1284549823-6246-1-git-send-email-arun.murthy@stericsson.com>
 <20100915082014.99d702e4.randy.dunlap@oracle.com>
 <F45880696056844FA6A73F415B568C69532D96AA36@EXDCVYMBSTM006.EQ1STM.local>
 <20100915104105.e77dfe8c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915104105.e77dfe8c.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, Sep 15, 2010 at 10:41:05AM -0700, Randy Dunlap wrote:
> I don't know what the __crc_* symbols are (I can't find them anywhere).
> 
> The other functions (pwm_config, pwm_free, pwm_request, pwm_disable,
> pwm_enable) exist in multiple places.  This is not good.
> They are very generically named.  The instances of these that are
> provided by platform code are OK (these):
> 
> ./include/linux/pwm.h:19:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
> ./arch/arm/plat-pxa/pwm.c:64:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> ./arch/arm/plat-pxa/pwm.c:101:EXPORT_SYMBOL(pwm_config);
> ./arch/arm/plat-samsung/pwm.c:194:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> ./arch/arm/plat-samsung/pwm.c:281:EXPORT_SYMBOL(pwm_config);
> ./arch/arm/plat-mxc/pwm.c:55:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> ./arch/arm/plat-mxc/pwm.c:114:EXPORT_SYMBOL(pwm_config);
> ./arch/mips/jz4740/pwm.c:94:int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> 
> but the instances of these that are defined in
> drivers/mfd/twl6030-pwm.c should not be named so generically.
> 
> Changing (Fixing) the function names in twl6030-pwm.c should fix the build problem
> that you reported, I think.  
The pwm "API" relies on someone providing the pwm_* symbols, and then you have
leds_pwm or backlight_pwm calling those symbols out of the blue.
If we change the twl6030-pwm.c function names, no pwm users (backlight, led or
input) will actually be able to use the twl6030 PWM driver.
The pwm API is very poorly designed in my opinion and should provide a way for
pwm drivers to register against it. pwm users will then call into the pwm
framework who would select which driver to use.

> And it will still allow the ab8500 driver to be
> built on other platforms, which is what we prefer when that is possible.
I agree with that, but couldnt see any other fix with the current pwm
situation.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
