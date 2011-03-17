Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1CQRwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:52:17 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34084 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab1CQRwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:52:14 -0400
Date: Thu, 17 Mar 2011 10:52:10 -0700
From: Andres Salomon <dilinger@queued.net>
To: Ed W <lists@wildgooses.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, rpurdie@rpsys.net,
        linux-geode@lists.infradead.org, const@mimas.ru,
        linux-kernel@vger.kernel.org
Subject: Re: Feedback please: [PATCH] leds: New PCEngines Alix LED driver
 using gpio interface
Message-ID: <20110317105210.420e55c4@queued.net>
In-Reply-To: <4D8243E7.7030309@wildgooses.com>
References: <4D81D7FD.1040602@wildgooses.com>
	<20110317084328.41831b4c@debxo>
	<AANLkTikga=zrNgfsuN4=8tCfZz0n7vkk6i0xW-zj6zSD@mail.gmail.com>
	<4D8243E7.7030309@wildgooses.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 17:24:55 +0000
Ed W <lists@wildgooses.com> wrote:

> On 17/03/2011 16:08, Grant Likely wrote:
> > Actually, it looks like with your changes this isn't even a driver
> > anymore.  It is merely code to register a device on a specific
> > platform.  Is there any other alix-specific initialization code in
> > the kernel?  If so, you should consider relocating the device
> > registration with the rest of the alix setup code.
> 
> Agreed.  I confess that I don't understand the linux driver structure
> enough to shift the code further though
> 
> What I observe is that there is a lot of arch specific setup for ARM,
> etc, however, this is not currently done at all for x86 (which is
> Alix), so at the moment this would seem to sit slightly awkwardly
> with current x86 arch code?
> 
> Instead I found leds-net5501.c, which is for a very similar platform
> to the Alix (not quite similar enough that I could combine the files)
> and I used that as my prototype for this driver.
> 

OLPC stuff lives in arch/x86/platform/olpc; if there was more
alix-specific stuff, I'd suggest moving it into something similar.
However, I didn't find any.  Maybe an arch/x86/platform/geode as a
place to collect platform drivers for the various geode-based machines
out there (alix, soekris, etc)?  Though honestly, I'm not that
interested in doing the work to migrate stuff over to there.


> I think given that we already have a similar driver in the leds area
> which does platform alike setup, this gives some justification for
> doing the same with the Alix leds?  Additionally if we ever find we
> need Alix specific setup code then the code is ready to be used as is
> by the platform code?
> 
> 
> >>> -module_init(alix_led_init);
> >>> -module_exit(alix_led_exit);
> >>> +arch_initcall(alix_init);
> >>
> >> Why is this arch_initcall rather than module_init?   If possible,
> >> it would be good to have an unload hook as well.
> > 
> > Yes, unless you've got specific ordering constraints this should
> > definitely be module_init().
> 
> I'm out of my depth here.  I would be very happy to resubmit either
> way?
> 
> However, is there not a potential ordering issue if leds-alix2 is
> loaded *before* leds-gpio? Is this not the reason for making it an
> arch_initcall?
> 
> Also the same code is used in leds-5501.c - would you like me to
> submit a patch to change that also (if you confirm it should become a
> module_init call?).

Yes, it should be module_init.  There shouldn't be any issues with
leds-gpio; the driver will only bind once a device is added (so long as
nothing else named leds-gpio comes along before leds-alix2).

> 
> Thanks for final confirmation on this and I will quickly resubmit the
> patch?
> 
> Ed W
