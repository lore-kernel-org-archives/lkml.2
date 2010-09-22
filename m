Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0IVPfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:35:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:55381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab0IVPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:35:22 -0400
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
From: David Woodhouse <dwmw2@infradead.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100922153321.GD32476@sirena.org.uk>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
	 <20100920150431.GD31167@sirena.org.uk>
	 <20100920152726.68ac2d84@linux.intel.com>
	 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
	 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
	 <1285168933.4498.119.camel@i7.infradead.org>
	 <20100922153321.GD32476@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 16:35:17 +0100
Message-ID: <1285169717.4498.121.camel@i7.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.33.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 16:33 +0100, Mark Brown wrote:
> On Wed, Sep 22, 2010 at 04:22:13PM +0100, David Woodhouse wrote:
> 
> > It makes *no* sense to add probe support for your 'special' platform
> > devices to drivers which already have (or will need anyway) proper
> > device-tree support.
> 
> To be fair they're not doing this, all this code is in the arch code
> rather than the driver code (which is a separate concern).
> 
> > Seriously, just convert whatever crap you have into a device-tree at
> > early boot (or preferably in the bootloader, and *beat* the firmware
> > idiots until they provide it natively), and don't pollute the kernel any
> > more than you have to with this idiocy.
> 
> This is roughly what it's doing except that it's going to native Linux
> bus types and platform data rather than to device tree.

It still means that drivers for chips which are seen both on this
bizarre abomination and also on other machines which use a device-tree
will need to support *both* probe types.

-- 
dwmw2

