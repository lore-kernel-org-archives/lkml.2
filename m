Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1GCVj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:39:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:46709 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab1GCVj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:39:57 -0400
Subject: Re: [PATCH v2 02/19] OpenRISC: Device tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <CACxGe6tFX=EQjaL-4EjSXquY5eh+bca29=d=cE5-YAVCUVRCvA@mail.gmail.com>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
	 <1309641352-18714-3-git-send-email-jonas@southpole.se>
	 <CACxGe6tFX=EQjaL-4EjSXquY5eh+bca29=d=cE5-YAVCUVRCvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 07:39:38 +1000
Message-ID: <1309729178.14501.264.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-03 at 14:51 -0600, Grant Likely wrote:
> > +
> > +#ifdef CONFIG_PCI
> > +/*
> > + * PCI <-> OF matching functions
> > + * (XXX should these be here?)
> > + */
> > +struct pci_bus;
> > +struct pci_dev;
> > +extern int pci_device_from_OF_node(struct device_node *node,
> > +                                       u8 *bus, u8 *devfn);
> > +extern struct device_node *pci_busdev_to_OF_node(struct pci_bus
> *bus,
> > +                                                       int devfn);
> > +extern struct device_node *pci_device_to_OF_node(struct pci_dev
> *dev);
> > +extern void pci_create_OF_bus_map(void);
> > +#endif

Don't copy these from powermac or microblaze. the OF_bus_map is
something that should not spread :-)

You get all you need of the above from generic code with my patches to
PCI <-> OF matching, which should be in linux-next and are going to be
merged in the next merge window.

Cheers,
Ben.


