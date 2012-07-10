Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2GJGt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:49:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2GJGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:49:54 -0400
Date: Tue, 10 Jul 2012 08:49:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Chris Ball <cjb@laptop.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Boot regression on Mackerel with current mainline
In-Reply-To: <87ipdws1mc.fsf@octavius.laptop.org>
Message-ID: <Pine.LNX.4.64.1207100845130.29825@axis700.grange>
References: <201207031218.24797.rjw@sisk.pl> <Pine.LNX.4.64.1207031336320.29890@axis700.grange>
 <201207031910.24864.rjw@sisk.pl> <Pine.LNX.4.64.1207041125330.21042@axis700.grange>
 <87ipdws1mc.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Awuc0+gE+OIKKpHnHHgQJsb/0+M1IfFuo4cdqjoiVcH
 PU4WunXa7VXOWFmdyXnsA12Y+vqrRPN1n/5CGr+GX/yGIc9fMU
 FKYKRHUp9eNMfhA26CuROZfFEVK9x/eiWz3JW4dkjqgw5ElQJD
 N44HZ9jhBYYnyhNGrxY6vDzaPkKWhxH2DL9IvNLhjsks9zhL8f
 2KJIIKCnNJ1yV6nL4rO9EVuoxEKosh2oT5hbI/fx0ljfJRWDK/
 nm72GqvPLk+Zt58+KVcNUpEh+4nbHQVN3WTHclUCTuNjAOePSA
 LJnnVKByDsV9MQfavHOa/vtUJMwYQ4Fro7gmPIvYUCZ4KVNb72
 0vStha1EzP7MZO0TVCQWekzMAvS/w/zeHWqO9KFoybPYKr4Wst
 uboUbvLxGNGoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris

On Tue, 10 Jul 2012, Chris Ball wrote:

> Hi Guennadi,
> 
> On Wed, Jul 04 2012, Guennadi Liakhovetski wrote:
> > On Tue, 3 Jul 2012, Rafael J. Wysocki wrote:
> >
> >> On Tuesday, July 03, 2012, Guennadi Liakhovetski wrote:
> >> > Hi Rafael
> >> > 
> >> > On Tue, 3 Jul 2012, Rafael J. Wysocki wrote:
> >> > 
> >> > > Hi,
> >> > > 
> >> > > We seem to have a functional regression on Mackerel with 3.5-rc5 which
> >> > > seems to be related to SDHI.  Namely, the SDHI driver appears to wait forever
> >> > > for the devices to appear and commenting out all of the sdhi devices in the
> >> > > board file works around the problem.
> >> > > 
> >> > > I can investigate some more later today if need be.
> >> > 
> >> > Have you checked the logs? Are you seeing any of these in the kernel log:
> >> > 
> >> > genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq 
> >> 
> >> I see this only once per boot, but then sh_mobile_sdhi is saying "timeout
> >> waiting for hardware interrupt" pretty much continuously.
> >
> > Yes, that's the one. Ok, let's fix it in the driver. In fact, a fix has 
> > already been submitted, but for 3.6. I hoped, 3.5 would resort to a softer 
> > form of the ONESHOT failing, so, I didn't push it for -rc. I think, the 
> > easiest would be to apply these two patches:
> >
> > "mmc: tmio: use MMC opcode defines instead of numbers"
> > http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=598cd9cc217b0aa46089a3838a8b1c37b97aa08b
> >
> > and
> >
> > "mmc: extend and rename cd-gpio helpers to handle more slot GPIO functions"
> > http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=d8e60fb51effc83e6f53de191a8440f46e5a3f2c
> >
> > The latter one looks big because of a rename, but with "-M" it's pretty 
> > trivial. Chris, do you agree?
> 
> Is the minimal fix to just add "| IRQF_ONESHOT" to the request_threaded_irq
> argument?  If so, I'd rather push just that for 3.5, and I can take care of
> having that change appear simultaneously in linux-next so that there aren't
> any conflicts.  Is that okay with you?

For that you'd have to rebase -next, right? you'd like to do that? Because 
the patch

"mmc: extend and rename cd-gpio helpers to handle more slot GPIO functions"
http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=d8e60fb51effc83e6f53de191a8440f46e5a3f2c

obviously would conflict with adding "| IRQF_ONESHOT". Either would work 
with me, sure. Would you like me to submit this trivial ONESHOT fix and an 
updated version of the above patch, or would you prefer to do this 
yourself?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
