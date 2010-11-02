Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0KBU0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:26:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39355 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752045Ab0KBU0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:26:30 -0400
Date: Tue, 2 Nov 2010 16:26:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
Message-ID: <20101102202636.GA32103@opensource.wolfsonmicro.com>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
 <1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
 <20101102131146.GA21476@opensource.wolfsonmicro.com>
 <AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
 <20101102143534.GG21476@opensource.wolfsonmicro.com>
 <AANLkTimuT8__KJE1V9f8PoFCxUjYW6n=35mLH4wBVdvM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimuT8__KJE1V9f8PoFCxUjYW6n=35mLH4wBVdvM@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 09:43:30PM +0200, Felipe Contreras wrote:
> On Tue, Nov 2, 2010 at 4:35 PM, Mark Brown

> > This solution doesn't seem like it scales so well either, it just shifts
> > it into the Kconfig files (where everything is all in central files
> > shared by everyone which has its own problems).  Certainly the goal of
> > replacing defconfig files with Kconfig seems unattainable.

> The difference is that Kconfig files are needed, and part of linux
> itself. The defconfig files should be optional, there are many, and
> not necessarily in the linux tree (e.g. meego kernel configs).

Right, but it's not like you're ever going to get a useful machine
configuration just using Kconfig except in the most trivial systems.

> However, even if you forget about Kconfig vs defconfig, it should be
> possible to create a .config file from nothing, and when you do that,
> having REGULATOR_TWL4030 enabled when you enable REGULATOR support
> just makes sense (if you have enabled TWL4030_CORE).

Right, but everyone uses the same Kconfig files while the defconfigs
only affect the individual platform which uses them.  This is annoying
for me since it increases the amount of stuff that gets built into my
kernel (I routinely build everything I possibly can in my subsystems for
coverage but don't actually want to have all that stuff show up in the
kernel image I'm running on my system).  The stuff ends up built in due
to the issue with MFDs not being buildable as modules since they have
interrupt controllers, if that were fixed it wouldn't be an issue.

If you're going to make this sort of change we need to have a policy
change over all MFD subdevices (and possibly some other things) and
decide that we'll eat the costs.  Doing it randomly for individual
chips and drivers within those chips doesn't seem like a good approach.
