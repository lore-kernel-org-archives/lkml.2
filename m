Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0IWJyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:54:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38678 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752481Ab0IWJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:54:13 -0400
Date: Thu, 23 Sep 2010 10:54:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923095411.GA25663@rakim.wolfsonmicro.main>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
 <20100920150431.GD31167@sirena.org.uk>
 <20100920152726.68ac2d84@linux.intel.com>
 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
 <20100922231514.5e9967c7@linux.intel.com>
 <20100923060703.GB11198@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923060703.GB11198@angua.secretlab.ca>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 03:07:03AM -0300, Grant Likely wrote:

> My point is that an isolated translation layer becomes
> (exponentially?) more difficult to maintain for each additional
> platform that depends on it.  Support must be explicitly added for
> every device that gets attached to a moorestown system in a way that
> cannot be modularized and has the potential to become very large.

It's not just the per-device aspect of it, it's also what happens when
OEMs start placing devices with no upstream defined mappings on their
boards.  Regardless of any specs it seems unlikely that OEMs can be
reliably persuaded to coordinate the creation of new SFI mappings for
these devices with anyone which means that we're likely to end up with
multiple incompatible definitions.  Looking at the code as it is I don't
see any structure in there for handling that - it's assuming that we
know what the platform data for a given device is going to look like.

> From what I've seen tonight, dumping SFI data verbatim into a device
> tree isn't an option because SFI doesn't naturally group device data.
> I withdraw the suggestion.  So, I guess I agree.  There doesn't seem
> to be any way around machine-specific SFI translation code, regardless
> of whether it translates into direct registrations, or into a device
> tree.

One thing that might help here is to put in place the mechanisms for
adding board-specific overrides now (I'm presuming there's board naming
data in the SFI somewhere, I've not looked).  That should hopefully
provide some hints to people and would at least mean we've got something
to hang machine specific workarounds on.

To be honest I'd actually be inclined to go more towards the way the
non-DT embedded platforms have gone and just ignore the data we get
from SFI as much as possible and have board specific initialisation in
code; it's boring and repetitive but it's also clear and *relatively*
robust.

> > If a driver wants device tree the SFI parser would ideally supply it
> > with device tree. If the entire kernel goes device tree I will whoop
> > with joy and make SFI use it.

> :-)

To be honest I suspect we'll have similar issue with or without device
tree.
