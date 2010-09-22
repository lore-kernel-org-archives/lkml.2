Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab0IVWvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:51:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:30425 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0IVWu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:50:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,220,1283756400"; 
   d="scan'208";a="609474688"
Date: Wed, 22 Sep 2010 23:04:06 +0100
From: Alan Cox <alan@linux.intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100922230406.6b944797@linux.intel.com>
In-Reply-To: <1285168933.4498.119.camel@i7.infradead.org>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
	<20100920150431.GD31167@sirena.org.uk>
	<20100920152726.68ac2d84@linux.intel.com>
	<20100920152705.GJ3414@rakim.wolfsonmicro.main>
	<AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
	<1285168933.4498.119.camel@i7.infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch (and SFI in general) seems like entirely the wrong
> approach. You're gratuitously reinventing the wheel, and your
> proposed replacement isn't even round.

SFI is what is implemented on these platforms. SFI is what you get. Now
it's possible the firmware folks may move away from SFI for future
hardware but that remains 

> As Grant says, we already have a defined method for passing this kind
> of information to the kernel. We have well-thought-out bindings for

No we don't. The existing drivers we need don't support it.

> It makes *no* sense to add probe support for your 'special' platform
> devices to drivers which already have (or will need anyway) proper
> device-tree support.

I've not seen any which have device tree support that are being used.

> Seriously, just convert whatever crap you have into a device-tree at
> early boot (or preferably in the bootloader, and *beat* the firmware
> idiots until they provide it natively), and don't pollute the kernel
> any more than you have to with this idiocy.

Thats why its in arch/x86/kernel/mrst.c - an arch private file specific
to the platform which then provides platform data in the format drivers
already use.

It's really quite simple

If drivers expect device tree the mrst.c code can provide device tree -
but in the real world none we care about do so yet. If stuff moves to
device tree then the translation will move that way because its job is
to convert SFI to what the kernel wants.

Right now the kernel wants a mix of private structs and as far as
possible platform_foo() stuff. When that is changes the rest will
follow.

Alan


