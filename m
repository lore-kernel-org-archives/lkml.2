Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2IBVjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:39:44 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4199 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2IBVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:39:43 -0400
From: Maarten ter Huurne <maarten@treewalker.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Date: Sun, 02 Sep 2012 23:34:32 +0200
Message-ID: <1494411.dJ2nCQkPX8@hyperion>
User-Agent: KMail/4.9 (Linux/3.1.10-1.16-desktop; KDE/4.9.0; x86_64; ; )
In-Reply-To: <20120902192752.GA10930@avionic-0098.mockup.avionic-design.de>
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de> <1890769.KjIbOv8Xbz@hyperion> <20120902192752.GA10930@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2012 21:27:53 Thierry Reding wrote:
> On Sun, Sep 02, 2012 at 03:25:55PM +0200, Maarten ter Huurne wrote:
> > I tested the "for-next" branch on the Dingoo A320 with the pwm-backlight
> > driver. It didn't work at first, because the PWM number and the timer
> > number didn't align: I requested PWM number 5 to get PWM7 and the GPIO
> > of PWM7 was used, but with timer 5 instead of timer 7, resulting in a
> > dark screen. However, it works fine after adding PWM0/1 as described
> > above.
> 
> I haven't seen any usage of the pwm-backlight driver in mainline. I
> assume this is only present in some downstream repository?

Yes, the Dingoo A320 support is currently only available in the qi-kernel 
repository. We have some essential drivers (the SLCD framebuffer driver in 
particular) that are in their current state just too ugly to submit to 
mainline.

> > If other people want to test on real hardware, you can find the code in
> > branch jz-3.6-rc2-pwm in the qi-kernel repository. Unfortunately our web
> > interface for git is still broken, but the repo itself is fine.
> > 
> >   git://projects.qi-hardware.com/qi-kernel.git

This is where you can find the code. The relevant configs are 
qi_lb60_defconfig and a320_defconfig.

> An alternative approach would be to change pwm_chip.base from -1
> (dynamically allocated) to 2, which would leave 0 and 1 unavailable.
> That should at least solve the problem that you had regarding the GPIO
> and timer mismatch.

That could work, but the hardware does have PWM0 and PWM1, which are just 
not available in our kernel, so adding them in busy state would better 
describe real situation.

Maybe at some point we'll have a generic timer framework as well and then 
having PWM0/1 defined but not requestable because the timers are busy would 
be a natural fit.

> But the above also sounds sensible, and since both you and Lars agree
> that this is the better option, I can squash these changes into my patch
> with your permission.

Yes, please do.

Bye,
		Maarten

