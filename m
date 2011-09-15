Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab1IOLBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 07:01:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57893 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IOLBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 07:01:21 -0400
Date: Thu, 15 Sep 2011 12:00:56 +0100
From: Russell King <rmk+alsa@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build
	failure
Message-ID: <20110915110056.GA32615@flint.arm.linux.org.uk>
References: <1315991893.17271.2.camel@phoenix> <20110914191917.GA30518@flint.arm.linux.org.uk> <20110914232808.GC2953@opensource.wolfsonmicro.com> <20110914233838.GB22946@flint.arm.linux.org.uk> <20110915094640.GA7988@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915094640.GA7988@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 10:46:41AM +0100, Mark Brown wrote:
> On Thu, Sep 15, 2011 at 12:38:39AM +0100, Russell King wrote:
> > On Thu, Sep 15, 2011 at 12:28:09AM +0100, Mark Brown wrote:
> > > On Wed, Sep 14, 2011 at 08:19:17PM +0100, Russell King wrote:
> 
> > > ...this is true a substantial proportion of the GTA01 devices out there
> > > are in the hands of people who might hack on it.
> 
> > Point at a mainline kernel which includes support for the neo1973_gta01
> > platform.
> 
> I don't recall saying that there has been one; however I have seen
> reasonable (if sporadic) efforts at getting the two boards mainlined -
> it took years to get GTA02 in there but it did happen.

Look - we have a fundamental problem with the mach-types file, and
that is it's growing completely out of hand.  The full file is 150k
representing some 3600 platforms.  When it's postprocessed, it
produces a 1.3MB header file.

Of that, only 21k or around 500 platforms have been merged into the
kernel, producing a 180k header file.

The amount of effort required to maintain that file is getting
rediculous - manually removing entries for SoCs rather than platforms,
manually removing entries which have been partially edited which could
conflict with other entries etc.  Something _has_ to change - and it
has - and did about six months ago.

We now have a sane policy: entries which aren't fully up to date are
automatically dropped.  Entries for which there is no platform support
file merged within 12 months of the entries last edit are dropped also
automatically dropped.

This policy results in a 50k file, representing around 1100 platforms
exploding to about 400k of header file.  I think that is a reasonable
compromise, and I think the policy is entirely reasonable.

Lastly, GTA01 board support was added to the ALSA stuff in 2008 without
the main platform support in arch/arm - so it can't be usefully used.
It's been three years since that was done and still there is no sign of
the main platform support appearing.  It's been five years since the
entry was created in the machine database.

Face it, GTA01 is dead as far as mainline is concerned.

If it's not dead then it needs sorting out.  Either way there's two
valid states:  1. fully merged, or 2. none of it is merged.
There's no real half-way house state - certainly not one which should
persist for three years.  (It would be reasonable for maybe a couple
of kernel releases but more than that is becoming very much a joke.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
