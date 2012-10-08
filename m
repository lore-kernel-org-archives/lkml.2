Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2JHCqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 22:46:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59872 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2JHCqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 22:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <20121004191308.GB7228@avionic-0098.mockup.avionic-design.de>
References: <1349330819-11924-1-git-send-email-thierry.reding@avionic-design.de>
 <506DA487.9070400@metafoo.de> <20121004182931.GA7228@avionic-0098.mockup.avionic-design.de>
 <506DDA16.8070604@metafoo.de> <20121004191308.GB7228@avionic-0098.mockup.avionic-design.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 8 Oct 2012 10:45:44 +0800
Message-ID: <CAMPhdO-PiKwYstKrGwdhrUG3+KWhPioAtzPVqtk52vss-4M+iw@mail.gmail.com>
Subject: Re: [PATCH] pwm: Get rid of HAVE_PWM
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 3:13 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Thu, Oct 04, 2012 at 08:48:54PM +0200, Lars-Peter Clausen wrote:
>> On 10/04/2012 08:29 PM, Thierry Reding wrote:
>> > On Thu, Oct 04, 2012 at 05:00:23PM +0200, Lars-Peter Clausen wrote:
>> >> On 10/04/2012 08:06 AM, Thierry Reding wrote:
>> >>> [...]
>> >>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>> >>> index 331d574..b38f23d 100644
>> >>> --- a/arch/mips/Kconfig
>> >>> +++ b/arch/mips/Kconfig
>> >>> @@ -219,7 +219,8 @@ config MACH_JZ4740
>> >>>   select GENERIC_GPIO
>> >>>   select ARCH_REQUIRE_GPIOLIB
>> >>>   select SYS_HAS_EARLY_PRINTK
>> >>> - select HAVE_PWM
>> >>> + select PWM
>> >>> + select PWM_JZ4740
>> >>>   select HAVE_CLK
>> >>>   select GENERIC_IRQ_CHIP
>> >>
>> >> I'm not sure if this is such a good idea, not all jz4740 based board
>> >> necessarily require PWM.
>> >
>> > This really only restores previous behaviour. But I agree that this is
>> > potentially not what we want. Maybe we should just not select this for
>> > any boards but rather leave it up to some default configuration. If so
>> > the patch can be made simpler by just removing the HAVE_PWM entries.
>>
>> At least for JZ4740 I think that is the better solution.
>
> Okay, I'll give other people the chance to comment on this. Especially
> for PXA there are many boards that use the PWM for backlight and it
> would be interesting to hear from them how they want this to be handled.

I'd say the original intention to introduce HAVE_PWM (although PXA
makes a lot use of this, but I remember Russell was the first to propose
this), is for board config to indicate its potential usage of the PWM or
rather if PWM is available for use on the board, and then leave the
developer another config option to build or not-to-build.

Personally I think removing HAVE_PWM will simplify the code a bit
and that's a good thing, on the other hand, how to keep a certain level
of flexibility mentioned above remains a small question. I guess with
device tree, this can be mitigated a bit.
