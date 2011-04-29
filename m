Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1D2Lro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 07:47:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:53552 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab1D2Lrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 07:47:42 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <201104291326.25634.arnd@arndb.de>
References: <201104212129.17013.arnd@arndb.de>
	 <20110428093039.GU17290@n2100.arm.linux.org.uk>
	 <1304024836.2513.198.camel@pasglop>  <201104291326.25634.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 21:47:21 +1000
Message-ID: <1304077641.2513.242.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 13:26 +0200, Arnd Bergmann wrote:
> On Thursday 28 April 2011, Benjamin Herrenschmidt wrote:
> > > > 
> > > > For PCI you can have the flag propagate from the PHB down, for busses
> > > > without a bus type (platform) then whoever instanciate them (the
> > > > platform code) can set that appropriately.
> > > 
> > > How can you do that when it changes mid-bus heirarchy?  I'm thinking
> > > of the situation where the DRM stuff is on a child bus below the
> > > root bus, and the root bus has DMA coherent devices on it but the DRM
> > > stuff doesn't.
> > 
> > But that's not PCI right ? IE. with PCI, coherency is a property of the
> > PHB... 
> 
> That is my understanding at least, but I'd like to have a confirmation
> from the DRM folks.
> 
> I believe that the PC graphics cards that have noncoherent DMA mappings
> are all of the unified memory (integrated into the northbridge) kind,
> so they are not on the same host bridge as all regular PCI devices,
> even if they appear as a PCI device.

Hrm... beware with x86 , they love playing tricks :-) Since too many
BIOSes don't understand PCI domains, they make devices on separate
bridges look like sibling on the same segment and that sort of thing.

Cheers,
Ben.

