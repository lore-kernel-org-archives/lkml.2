Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab1IOMGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:06:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40234 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IOMGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:06:52 -0400
Date: Thu, 15 Sep 2011 13:06:27 +0100
From: Russell King <rmk+alsa@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build
	failure
Message-ID: <20110915120627.GB32615@flint.arm.linux.org.uk>
References: <1315991893.17271.2.camel@phoenix> <20110914191917.GA30518@flint.arm.linux.org.uk> <20110914232808.GC2953@opensource.wolfsonmicro.com> <20110914233838.GB22946@flint.arm.linux.org.uk> <20110915094640.GA7988@opensource.wolfsonmicro.com> <20110915110056.GA32615@flint.arm.linux.org.uk> <4E71E720.7040008@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E71E720.7040008@metafoo.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 01:53:04PM +0200, Lars-Peter Clausen wrote:
> On 09/15/2011 01:00 PM, Russell King wrote:
> > [...]
> > We now have a sane policy: entries which aren't fully up to date are
> > automatically dropped.  Entries for which there is no platform support
> > file merged within 12 months of the entries last edit are dropped also
> > automatically dropped.
> 
> Partly unrelated, but what about these platforms which can be fully described
> with DT and don't need a platform file?

The theory is with DT is that machine_is_xxx() is no longer required,
because they're fully described by DT.  Such a kernel should not care
whether it's running on board XYZ or ABC because the differences are
wrapped up in the DT description of it.

Moreover, DT boards do not have machine IDs - their machine ID is "~0"
which will be universal for all DT using platforms.  So machine_is_xxx()
really has no meaning at all when using DT.  Basically, DT makes machine
IDs obsolete.

> The code for GTA01 is out there and could be merged into mainline, but
> I think it would be dead code since there doesn't seem to be really
> any interest in the device anymore.
> 
> So just get rid of the gta01 portions of the neo1973_wm8753 driver.
> If GTA01 support ever gets merged we can still revert the removal.

Agreed.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
