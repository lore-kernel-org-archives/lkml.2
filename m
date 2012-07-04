Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab2GDJjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:39:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab2GDJj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:39:29 -0400
Date: Wed, 4 Jul 2012 11:39:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>
Subject: Re: Boot regression on Mackerel with current mainline
In-Reply-To: <201207031910.24864.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1207041125330.21042@axis700.grange>
References: <201207031218.24797.rjw@sisk.pl> <Pine.LNX.4.64.1207031336320.29890@axis700.grange>
 <201207031910.24864.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:fH8fGaPb3j2Bg58uyLyBYFJYO/mOToYvioDglBIY57z
 UDPxHMbYXTnKPuJebGdZCuyfUkVEZ1GC27pn8KbvRinO3jqZxg
 189DZ9j7UXer++tCDBlTkNewm+2GvaBnWz0H4yUmBmHAjvRweU
 8VhzPhwOdsWuRFZtrcfrNY3a1Q3y884hK8bC98d5n6MLIAnHZ+
 pTbRhnyGcAfWlOlZRnwEdg/c0BinnH1lMgTOwZpakZe6AQM9+l
 x1PqMEN3Hsr1kXrybNzD/L4iMi6bzqgJeWfIjH8RyCxSCdL8Lc
 yFhxw5nnktatUd+ju+4EqoJ1RfXZKNg+lBSNthjuUIvnlisAir
 huhNUn9pSlTKozCfkgBX9ERjXorDYR9VSVUdv6IkVb8U2bdFzJ
 XIQelLu6FY9rg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012, Rafael J. Wysocki wrote:

> On Tuesday, July 03, 2012, Guennadi Liakhovetski wrote:
> > Hi Rafael
> > 
> > On Tue, 3 Jul 2012, Rafael J. Wysocki wrote:
> > 
> > > Hi,
> > > 
> > > We seem to have a functional regression on Mackerel with 3.5-rc5 which
> > > seems to be related to SDHI.  Namely, the SDHI driver appears to wait forever
> > > for the devices to appear and commenting out all of the sdhi devices in the
> > > board file works around the problem.
> > > 
> > > I can investigate some more later today if need be.
> > 
> > Have you checked the logs? Are you seeing any of these in the kernel log:
> > 
> > genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq 
> 
> I see this only once per boot, but then sh_mobile_sdhi is saying "timeout
> waiting for hardware interrupt" pretty much continuously.

Yes, that's the one. Ok, let's fix it in the driver. In fact, a fix has 
already been submitted, but for 3.6. I hoped, 3.5 would resort to a softer 
form of the ONESHOT failing, so, I didn't push it for -rc. I think, the 
easiest would be to apply these two patches:

"mmc: tmio: use MMC opcode defines instead of numbers"
http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=598cd9cc217b0aa46089a3838a8b1c37b97aa08b

and

"mmc: extend and rename cd-gpio helpers to handle more slot GPIO functions"
http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=d8e60fb51effc83e6f53de191a8440f46e5a3f2c

The latter one looks big because of a rename, but with "-M" it's pretty 
trivial. Chris, do you agree?

Thanks
Guennadi

> > with an IRQ number at the end? If so, then this is a known problem, which 
> > I'd hoped would have been long fixed by now:
> > 
> > https://lkml.org/lkml/2012/6/12/151
> > 
> > We can nommit a fix for it in mmc, or we can try to re-ping Thomas - if 
> > this is indeed the bug, you're getting...
> 
> I guess it is, but having reviewed the above e-mail thread I don't think any
> fix from Thomas is going to appear.  So, please fix that in MMC, if possible.
> 
> Thanks,
> Rafael
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
