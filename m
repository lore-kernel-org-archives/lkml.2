Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0GNQWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:22:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62681 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0GNQWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:22:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6042"; a="47465524"
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for
 defconfig
From: Daniel Walker <dwalker@codeaurora.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <alpine.LFD.2.00.1007131941140.10598@xanadu.home>
References: <20100713230352.6781.18644.stgit@angua>
	 <1279062881.4609.34.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTin69tN3NQHD2wvkA0G-lj3f9tSZEnhzdyJdTh9m@mail.gmail.com>
	 <1279064008.4609.48.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1007131941140.10598@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 09:22:43 -0700
Message-ID: <1279124563.21162.14.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 20:07 -0400, Nicolas Pitre wrote:

> That's one issue indeed.
> 
> But there is another issue that is somewhat related, which is to be able 
> to categorize config options.
> 
> Currently the defconfig files carry information about the proper driver 
> to enable in order to support devices soldered on the board and 
> therefore which are not "optional".  That might be a particular RTC 
> chip, or a particular ethernet block integrated into a SOC, etc.  Of 
> course we want to preserve the ability to disable support for those 
> things, but by default people want to have all the right drivers 
> selected for all the built-in hardware when selecting a target 
> machine/board without having to dig into a datasheet for that target.
> 
> The defconfig files also carry config options that are totally 
> arbitrary.  What type of filesystem, what kind of network protocol, what 
> USB device drivers (not host controller driver), what amount of 
> debugging options, all those are unrelated to the actual hardware and 
> may vary from one user to another.

Right.

> Furthermore, in order to reduce the number of defconfig files, we tried 
> to combine as many targets into a single kernel image.  That increases 
> build test coverage with fewer builds which is good, but then the info 
> about specific drivers required for a specific target but not for 
> another target in the same defconfig is now lost.  It is therefore quite 
> hard to produce a highly optimized configuration for a single target 
> without doing some digging again.
> 
> So it is really in the Kconfig file that all those hardware specific 
> options can be expressed in a clear and readable way.  When BOARD_XYZ is 
> selected and STD_CONFIG is selected, then automatically select RTC_FOO, 
> select ETH_BAR, select LED_BAZ, etc. Of course we would want required 
> dependencies to be automatically selected as well.

I see..

> But all the rest is arbitrary and could be part of common shared 
> profiles or the like in defconfig format.

I'm sure most people will want to have a config isolated to their
specific device. That to me seems reasonable because everyone wants the
smallest possible kernel they can get for their given device.

Then there would be a smaller group who wants to create multi-device
images. I don't see this being the average users tho, or kernel hackers.

To me there is little difference between doing,

CONFIG_ARCH_MSM=y

or

select ARCH_MSM

they are basically doing the same thing. So doing anything in Kconfig is
a lateral move .. Converting over to Kconfig in this case doesn't makes
sense to me.

Could we do something more like adding an "#include" option into the
defconfigs .. Then you could create defconfigs that hold multiple
devices without a massive rework to what we currently have. 

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

