Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1D1VHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 17:07:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:45737 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab1D1VHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 17:07:39 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110428093039.GU17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de>
	 <201104271302.44249.arnd@arndb.de>
	 <20110427201605.GW17290@n2100.arm.linux.org.uk>
	 <201104272221.48601.arnd@arndb.de>
	 <20110427202603.GY17290@n2100.arm.linux.org.uk>
	 <1303940467.2513.188.camel@pasglop>
	 <20110428093039.GU17290@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 07:07:16 +1000
Message-ID: <1304024836.2513.198.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 10:30 +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 28, 2011 at 07:41:07AM +1000, Benjamin Herrenschmidt wrote:
> > 
> > > As I said above, I don't think bus code can do it.  Take my example
> > > above of a tulip pci device on x86 and a tulip pci device on ARM.  Both
> > > use the same PCI code.
> > > 
> > > Maybe something in asm/pci.h - but that invites having lots of bus
> > > specific header files in asm/.
> > > 
> > > A better solution imho would be to have an architecture callback for
> > > struct device which gets registered, which can inspect the type of
> > > the device, and set the flag depending on where it appears in the
> > > tree.
> > 
> > Now -that's gross :-)
> > 
> > For PCI you can have the flag propagate from the PHB down, for busses
> > without a bus type (platform) then whoever instanciate them (the
> > platform code) can set that appropriately.
> 
> How can you do that when it changes mid-bus heirarchy?  I'm thinking
> of the situation where the DRM stuff is on a child bus below the
> root bus, and the root bus has DMA coherent devices on it but the DRM
> stuff doesn't.

But that's not PCI right ? IE. with PCI, coherency is a property of the
PHB... 

> Your solution doesn't allow that - and I believe that's what Arnd is
> talking about.

Well, for the rest I'm thinking just bolt it into the platform until you
can put the property in the DT :-)

Cheers,
Ben.

