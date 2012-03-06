Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031292Ab2CFUzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:55:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031163Ab2CFUzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:55:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Pre-merge-window status of the arm-soc tree
Date: Tue, 6 Mar 2012 20:54:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Jamie Iles <jamie@jamieiles.com>, Kevin Hilman <khilman@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Eric Miao <eric.y.miao@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Colin Cross <ccross@android.com>, Shawn Guo <shawn.guo@linaro.org>,
        Roland Stigge <stigge@antcom.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203062054.55434.arnd@arndb.de>
X-Provags-ID: V02:K0:x1sUY8xkhhfnEZFxtVtXAqiTJxKDEdD5lVwCUqVF6jM
 rMTO38MJMLxaaxp75yJVXvhNsdJz9g9JOaqqQI5D8WJon5y9nC
 hmavY2pT1ZE6qtySVKO0UzSjsdCPCTzbaeo8US8FFb2A9JPUfc
 7y7RRr3Wf3u8+tnabiMjfjXRAml3Sn5m2ox9xxvTVHoQo047Z1
 JdqY0VpCQVaAqsOhY9hFO3e8LgYMDxuRNDxSymerWRMKfj7gHz
 z4hM3WRW8ld38Y/p4Ykei92L8cOa8O7P3dW9pWG/vnSQWWV8TE
 kJ3q0bufZ/sancB82RYIt1948p9FxGkUOYVUEarMbo6Y47sl4r
 aV4KlbUs7Cw6bxc97+EU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a summary of what we have today in the arm-soc tree, queued up for
v3.4, as I expect the merge window to open soon. We currently have exactly
50 topic branches merged into the for-next tree, with a total of 331
non-merge changesets. There are a few more pull requests outstanding for
the pxa and exynos platforms.

About half the patches are cleanups and device tree conversion, which
is a good indication that we're making progress there. There also seems
to be an increased interest in ARMv5 and earlier platforms (pxa, at91,
omap1, kirkwood, lpc32xx, sa1100), some of which are now moving over
to device tree probing (at91 rapidly, in fact).

Top contributors so far are:
     27 Nicolas Ferre
     25 Stephen Warren
     25 Jean-Christophe PLAGNIOL-VILLARD
     20 Peter De Schrijver
     19 Tony Lindgren
     17 Ohad Ben-Cohen
     15 Richard Zhao
     14 Fabio Estevam
     10 Benoit Cousson
      9 Roland Stigge

A few things have changed since the last merge window:

* We now have staging branches, to let subarch maintainers get their
patches into arm-soc early on, without having the actual commits
being stable yet. Right now the only one there is the kirkwood/dt
branch from Jason Cooper, but there can be more. These staging
branches will not be sent to Linus during the merge window,
the idea is that they get replaced with a final version that gets
merged into one of the next/* topic branches.

* Russell now has a branch that contains patches from his tree that
directly impact stuff in arm-soc. We had a lot of nasty conflicts
the last time around, which resulted in some of the patches from
arm-soc not making it in during the merge window. Pulling the
rmk/for-armsoc branch into arm-soc hopefully lets us avoid this
situation in the future because we will fix the conflicts much
earlier.

* I have taken the rpmsg branch from Ohad Ben-Cohen into arm-soc.
While this is not strictly what arm-soc is for, a lot of us are
waiting for the branch to get in, and we hope that Linus will take
it from us, while he was cautious the last time when Ohad was sending
it as a new subsystem himself. Merging new subsystems through arm-soc
should not become the norm, but we can do it when it's really needed.

* There is some renewed interest in fixing 'make randconfig'. I
worked on this quite a bit last year but then didn't have the
energy to get all the patches integrated besides doing the
amr-soc maintainance. Russell has gotten more serious about it now,
and a few other people are helping out getting my original patches
integrated. If all goes well, we will soon get to the point where
we can use randconfig builds for automated regression testing and
just refuse to take pull requests into arm-soc if they break builds.

We are mostly converging on a set of topic branches that work for
all platforms, right now we have:

  fixes				bug fixes for 3.3
  next/fixes-non-critical       bug fixes for 3.4
  next/maintainers              updates to MAINTAINERS file
  next/cleanup                  any global cleanups
  next/soc                      soc-wide changes
  next/drivers                  driver related changes
  next/cleanup2                 cleanups depending on the former
  next/dt                       device-tree related changes
  next/boards                   board-specific changes
  next/soc2                     soc-wide changes with other dependencies
  next/rpmsg                    remoteproc and rpmsg
  staging/*			anything that is not quite ready

We can always add more if needed, just be careful not to introduce
any circular dependencies. E.g. today the next/dt branch depends on
patches in the next/drivers branch, so if you want to have other
conflicting patches in both branches, make sure that we can resolve
the branches in a way that lets the driver stuff come first. You will
find a list of the dependencies in the linux-next tree or in
arm-soc/for-next in the arch/arm/arm-soc-for-next-contents.txt file.

The overall changes today are
$ git diff for-next --dirstat=1                                                                                                                                                            
   1.4% Documentation/devicetree/bindings/arm/                                                                                                                                                                     
   4.1% Documentation/                                                                                                                                                                                             
   6.2% arch/arm/boot/dts/                                                                                                                                                                                         
   7.6% arch/arm/mach-at91/include/mach/                                                                                                                                                                           
  15.6% arch/arm/mach-at91/                                                                                                                                                                                        
   1.9% arch/arm/mach-davinci/                                                                                                                                                                                     
   5.6% arch/arm/mach-imx/                                                                                                                                                                                         
   2.2% arch/arm/mach-mxs/                                                                                                                                                                                         
   1.3% arch/arm/mach-omap1/                                                                                                                                                                                       
   3.0% arch/arm/mach-omap2/                                                                                                                                                                                       
   1.0% arch/arm/mach-tegra/include/mach/                                                                                                                                                                          
  17.0% arch/arm/mach-tegra/                                                                                                                                                                                       
   3.9% arch/arm/mach-ux500/                                                                                                                                                                                       
   2.2% arch/arm/mach-vexpress/                                                                                                                                                                                    
   1.9% arch/arm/plat-omap/include/plat/                                                                                                                                                                           
   5.4% arch/arm/                                                                                                                                                                                                  
   8.0% drivers/remoteproc/                                                                                                                                                                                        
   3.6% drivers/rpmsg/                                                                                                                                                                                             
   1.2% drivers/rtc/                                                                                                                                                                                               
   2.8% drivers/
   2.7% include/linux/

Notably absent here are still mach-msm and mach-shmobile and some
platforms have more patches pending. If you have anything that you
want to get included in 3.4, then now would be a good time to send
that. Anything that is not in arm-soc by the time the merge window
opens is not going to make it into the release, and you should allow
a little bit of time to sort out any conflicts between sending pull
requests and having them in the branch.

After Olof has handled the initial merges for v3.4 and I've been busy
doing the same in the last few -rc releases, I'm handing back over
to him now for the next week or two so I can work on some patches
of my own for a while.

	Arnd
