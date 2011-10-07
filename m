Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650Ab1JGJKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:10:10 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:2085 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab1JGJKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:10:07 -0400
Message-ID: <4E8EC1D8.4070200@atmel.com>
Date: Fri, 07 Oct 2011 11:09:44 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: linux-next: build failure after merge of the arm-soc tree
References: <20111004112623.aa04e959d29cb19af8053739@canb.auug.org.au> <201110040940.12876.arnd@arndb.de> <20111006111317.531e6fcc1829fc9927d4924d@canb.auug.org.au>
In-Reply-To: <20111006111317.531e6fcc1829fc9927d4924d@canb.auug.org.au>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 02:13 AM, Stephen Rothwell :
> Hi Arnd,
> 
> On Tue, 4 Oct 2011 09:40:12 +0200 Arnd Bergmann <arnd@arndb.de>
> wrote:
>> 
>> On Tuesday 04 October 2011, Stephen Rothwell wrote:
>>> After merging the arm-soc tree, today's linux-next build
>>> (x86_64 allmodconfig) failed like this:
>>> 
>>> ERROR: "clk_enable" [drivers/misc/atmel_pwm.ko] undefined! 
>>> ERROR: "clk_disable" [drivers/misc/atmel_pwm.ko] undefined! 
>>> ERROR: "clk_put" [drivers/misc/atmel_pwm.ko] undefined! ERROR:
>>> "clk_get_rate" [drivers/misc/atmel_pwm.ko] undefined! ERROR:
>>> "clk_get" [drivers/misc/atmel_pwm.ko] undefined!
>>> 
>>> Caused by commit 9dccc010c816 ("ARM: at91: remove dependency
>>> for Atmel PWM driver selector in Kconfig").
>>> 
>>> I have used the arm-soc tree from next-20110930 for today.
>> 
>> Ah, thanks for tracking this down. I actually noticed the same 
>> problem on an ARM build but did not realize it was from one of 
>> the patches I had jut put in there myself.
>> 
>> I'm really glad I didn't send this to Linus cc:stable yet then. 
>> Nicolas, in my randconfig branch, I've fixed this by adding
>> 
>> depends on HAVE_CLK
>> 
>> which I think is the right solution. I'll replace your patch with
>> one that does this if you don't mind.
>> 
>> I'd also remove the stable tag for this patch, because it can 
>> have unintended side-effects on other architectures.
> 
> I am still getting the failure ...

Well, on my side, applying Arnd's correction, I can run a x86_64
allmodconfig without this error.

With this new dependency it seems impossible to even select the driver.

Do you have a link to a log of this failure? Have the .config been
re-generated?

Best regards,
-- 
Nicolas Ferre
