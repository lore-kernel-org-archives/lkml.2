Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1LBXWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:22:41 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49295 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1LBXWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:22:38 -0500
X-Sasl-enc: WNOW8gW2TblucD7JwZJHhDsZyvxpb/6A9+ZW0zTHYaF7 1322868157
Date: Fri, 2 Dec 2011 15:16:45 -0800
From: Greg KH <greg@kroah.com>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: stable@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.11 backport 11b8fc6ae54bf18a48c94e181c37ca135b858b42 is
 broken, please revert
Message-ID: <20111202231645.GB6016@kroah.com>
References: <9233627B-1EC9-410E-A618-568A41CF4A59@dominion.thruhere.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9233627B-1EC9-410E-A618-568A41CF4A59@dominion.thruhere.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 11:26:41PM +0100, Koen Kooi wrote:
> Hi,
> 
> I noticed that audio stopped working after 3.0.10 which I narrowed down to:
> 
> 11b8fc6ae54bf18a48c94e181c37ca135b858b42 mfd: Fix twl4030 dependencies for audio codec
> 
> The commit message has this bit:
> 
> "In commit 57fe7251f5bfc4332f24479376de48a1e8ca6211
> the CONFIG_TWL4030_CODEC was renamed
> into CONFIG_MFD_TWL4030_AUDIO, thatswhy the codec
> was not detected."
> 
> Which is this one: http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=57fe7251f5bfc4332f24479376de48a1e8ca6211
> 
> Note the 4th of July date
> 
> koen@dominion:/OE/tentacle/build/tmp-angstrom_2010_x-eglibc/work/beagleboard-angstrom-linux-gnueabi/linux-3.0.12-r113a/git/drivers/mfd$ git log --oneline Kconfig
> 8509e14 mfd: Add Makefile and Kconfig Entries for tps65911 comparator
> 66c500f mfd: Fix build breakage caused by tps65910 gpio directory move
> 83545d8 GPIO: TPS65910: Move driver to drivers/gpio/
> c01e36d linux-next: build failure after merge of the voltage tree
> aec519b linux-next: build failure after merge of the voltage tree
> 27c6750 MFD: TPS65910: Add new mfd device for TPS65910
> c013f0a mfd: Add pm8xxx irq support
> cbdb53e mfd: Add Qualcomm PMIC 8921 core driver
> 1305134 mfd: Group NXP PCF50633* drivers together
> 37df003 mfd: Group TPSxxxxx power management chips together
> 8317797 mfd: add DB5500 PRCMU driver
> 650c2a2 mach-ux500: move the DB8500 PRCMU driver to MFD
> 
> Let's look at the top commit:
> 
> koen@dominion:/OE/tentacle/build/tmp-angstrom_2010_x-eglibc/work/beagleboard-angstrom-linux-gnueabi/linux-3.0.12-r113a/git/drivers/mfd$ git show 8509e14
> commit 8509e142567d69e170a184ecf27d7a6a3239fd72
> Author: Axel Lin <axel.lin@gmail.com>
> Date:   Thu Jun 23 10:15:51 2011 +0800
> 
> So the commit that is referenced is not actually in 3.0.x! Long story short:
> 
> git revert 11b8fc6ae54bf18a48c94e181c37ca135b858b42 is broken ; make ; scp uImage beagleboard
> 
> root@beagleboard:~# cat /proc/asound/cards 
> 0 [omap3beagle    ]:  - omap3beagle
>                      omap3beagle
> 
> So please revert  11b8fc6ae54bf18a48c94e181c37ca135b858b42 for 3.0.13,
> cherrypicking the TWL codec rename is a world of hurt since it needs
> other fixes to get pulled in as well.

Now reverted, thanks.

greg k-h
