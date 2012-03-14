Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab2CNIaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:30:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:38348 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab2CNI37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:29:59 -0400
Message-ID: <1331713762.3105.121.camel@pasglop>
Subject: Re: linux-next: manual merge of the devicetree tree with the
 powerpc tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 14 Mar 2012 19:29:22 +1100
In-Reply-To: <20120314015356.GA4028@shangw>
References: <20120313160100.c8cc3fd2b3d1f485ef7e7954@canb.auug.org.au>
	 <20120313182612.0546D3E053B@localhost> <20120314015356.GA4028@shangw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 09:53 +0800, Gavin Shan wrote:
> >  +#if defined(CONFIG_EEH)
> > >  +static inline struct eeh_dev *of_node_to_eeh_dev(struct device_node *dn)
> > >  +{
> > >  +  return dn->edev;
> > >  +}
> > >  +#endif
> > 
> > Ben, What is this?  I don't want the eeh_dev pointer in struct device_node.  Up to
> > now we've avoided putting any reverse references into device_nodes.  For everything
> > else we use a reverse lookup, particularly for devices, to avoid growing the
> > device_node for each new type of lookup.
> > 
> 
> It's used to trace the EEH device. When EEH (Enhanced Error Hanlding) is enabled,
> EEH device will be created against PCI sensitive OF node to trace the EEH state
> accordingly. Since you don't want see this in struct device_node, we have to change
> struct eeh_dev for a little bit to so that all struct eeh_dev instances will form
> a global list and we can search eeh_dev according to the given device_node through
> the global list. 
> 
> I don't know the policy or rule here for much. I think we can have 2 options.
> 
> 1. Keep the code as being, and fix it later.
> 2. Fix it now. 

My bad, it's a mis-review, I thought it was still in pci_dn, I din't
catch Gavin moving it to device-node.

Yes, Gavin, we need to do something else, a chained list we walk or
something like that. For the "fast path" which is when we have a pci_dev
around, we can either add it to dev_archdata or hijack the pci-dev
platform_data (I don't think anything uses it, Grant, do you know of
anything ?)

The patches are already in -next and I won't rebase, so we need to fix
it on top of the existing patches. Gavin, can you make a patch that puts
it back into pci_dn to begin with, then we can contemplate what better
long term solution we have ?

Cheers,
Ben.


