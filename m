Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1IPUEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 16:04:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39721 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab1IPUET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 16:04:19 -0400
Date: Fri, 16 Sep 2011 21:03:53 +0100
From: Russell King <rmk+alsa@arm.linux.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build
	failure
Message-ID: <20110916200353.GB18566@flint.arm.linux.org.uk>
References: <1315991893.17271.2.camel@phoenix> <20110914191917.GA30518@flint.arm.linux.org.uk> <20110914232808.GC2953@opensource.wolfsonmicro.com> <20110914233838.GB22946@flint.arm.linux.org.uk> <20110915094640.GA7988@opensource.wolfsonmicro.com> <20110915110056.GA32615@flint.arm.linux.org.uk> <4E71E720.7040008@metafoo.de> <56969.1316192529@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56969.1316192529@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 01:02:09PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 15 Sep 2011 13:53:04 +0200, Lars-Peter Clausen said:
> > On 09/15/2011 01:00 PM, Russell King wrote:
> > > [...]
> > > We now have a sane policy: entries which aren't fully up to date are
> > > automatically dropped.  Entries for which there is no platform support
> > > file merged within 12 months of the entries last edit are dropped also
> > > automatically dropped.
> > 
> > Partly unrelated, but what about these platforms which can be fully described
> > with DT and don't need a platform file?
> 
> Then those platforms won't notice if their now-unused entries evaporate out of
> the platform file, right?

Just to be clear: DT SoCs should be described with DT_MACHINE_START()
rather than MACHINE_START().  DT_MACHINE_START() sets the machine ID
to ~0, so using machine_is_xxx() is _intentionally_ useless in that
case - the point of DT is that DT itself is used to describe the
platform differences, not code based on machine type numbers.

Essentially, as DT progresses, the machine IDs should eventually
disappear and become completely redundant.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
