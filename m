Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1DDVDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:03:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:34951 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab1DDVD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:03:29 -0400
Subject: Re: [RFC/PATCH] of: Match PCI devices to OF nodes generically
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20110404.004856.55863268.davem@davemloft.net>
References: <1301882694.2549.53.camel@pasglop>
	 <1301887630.2549.71.camel@pasglop>
	 <20110404.004856.55863268.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 07:03:17 +1000
Message-ID: <1301950997.2549.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 00:48 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Mon, 04 Apr 2011 13:27:10 +1000
> 
> > +struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus)
> > +{
> > +	/* This should only be called for PHBs */
> > +	if (WARN_ON(bus->self || bus->parent))
> > +		return NULL;
> 
> This WARN_ON() will always trigger on sparc, because we use the OF
> device tree object at the "parent" of the PCI bus devices we create
> for the PCI controller domains.
> 
> I'm really surprised you don't link the PCI bus roots into the rest of
> the global device hierarchy on powerpc.

But in the above test bus->parent is the "struct pci_bus *" parent, not
the "struct device *" nor "struct device_node *" parent... That
shouldn't be linked to anything on a PHB.

To answer your other point, we do link PHBs on some platforms, not
others. Historical stuff here. Most of our platforms discover PCI
bridges very early from setup_arch() before we have any struct device
around. Mostly because that's how we always did and there's some
subtle/nasty corner cases to deal with if we change that.

Cheers,
Ben.

