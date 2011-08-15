Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1HOStY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:49:24 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:43775 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1HOStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:49:23 -0400
Date: Mon, 15 Aug 2011 14:49:07 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: martyn.welch@ge.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110815184907.GB22239@flamenco.cs.columbia.edu>
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
 <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch>
 <20110813074714.GA32149@flamenco.cs.columbia.edu>
 <20110815100503.GA22344@becoht-mvanga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815100503.GA22344@becoht-mvanga>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 12:05:03 +0200, Manohar Vanga wrote:
> > If the driver doesn't provide a .probe, we would still increment
> > the refcount of the bridge module. Is that reasonable? I dunno.
(snip)
> I picked this default behaviour from the PCI driver code (drivers/pci/pci-driver.c):
> 
> 	static int pci_device_probe(struct device * dev)
> 	{
> 		...
> 		pci_dev_get(pci_dev);
> 		error = __pci_device_probe(drv, pci_dev);
> 		if (error)
> 			pci_dev_put(pci_dev);
> 	
> 		return error;
> 	}
> 
> The __pci_device_probe() function checks if probe is present or not.

There is a subtle difference here; pci_dev is the _struct pci_device
of the device_ being probed, and pci_dev_get increments its refcount.

In our case vme_bridge_get increments the refcount of the _bridge's
module_; my concern was that if there was no .probe (which would
only happen with a few special drivers), we'd increment the refcount
of the bridge for perhaps no reason.

Anyway we don't have such esoteric drivers yet, so I wouldn't worry
about this too much.

		Emilio
