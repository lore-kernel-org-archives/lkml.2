Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab1D1Jaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:30:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51097 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1D1Jax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:30:53 -0400
Date: Thu, 28 Apr 2011 10:30:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428093039.GU17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <201104271302.44249.arnd@arndb.de> <20110427201605.GW17290@n2100.arm.linux.org.uk> <201104272221.48601.arnd@arndb.de> <20110427202603.GY17290@n2100.arm.linux.org.uk> <1303940467.2513.188.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303940467.2513.188.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 07:41:07AM +1000, Benjamin Herrenschmidt wrote:
> 
> > As I said above, I don't think bus code can do it.  Take my example
> > above of a tulip pci device on x86 and a tulip pci device on ARM.  Both
> > use the same PCI code.
> > 
> > Maybe something in asm/pci.h - but that invites having lots of bus
> > specific header files in asm/.
> > 
> > A better solution imho would be to have an architecture callback for
> > struct device which gets registered, which can inspect the type of
> > the device, and set the flag depending on where it appears in the
> > tree.
> 
> Now -that's gross :-)
> 
> For PCI you can have the flag propagate from the PHB down, for busses
> without a bus type (platform) then whoever instanciate them (the
> platform code) can set that appropriately.

How can you do that when it changes mid-bus heirarchy?  I'm thinking
of the situation where the DRM stuff is on a child bus below the
root bus, and the root bus has DMA coherent devices on it but the DRM
stuff doesn't.

Your solution doesn't allow that - and I believe that's what Arnd is
talking about.
