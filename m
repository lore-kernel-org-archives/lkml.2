Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab1KPEBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 23:01:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab1KPEBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 23:01:39 -0500
Message-ID: <1321416083.26410.8.camel@bling.home>
Subject: Re: 3.2rc1: bootup fails: DRHD: handling fault status reg 2
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Arnd Hannemann <arnd@arndnet.de>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Date: Tue, 15 Nov 2011 21:01:23 -0700
In-Reply-To: <1321347330.1932.65.camel@shinybook.infradead.org>
References: <4EC19738.8050007@arndnet.de> <4EC1B80D.5000102@arndnet.de>
	 <20111115043634.GA30247@sequoia.sous-sol.org>
	 <1321347330.1932.65.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 08:55 +0000, David Woodhouse wrote:
> On Mon, 2011-11-14 at 20:36 -0800, Chris Wright wrote:
> > As for the endless loop of DMAR faults...sounds like the Ricoh
> > cardbus/firewire issue where the firewire fucntion does DMA from
> > function 0.  I thought this was quirked and fixed though.
> 
> Alex? You were handling this as part of the IOMMU 'group' functionality,
> weren't you? Did you have a test machine... you do now :)

The group functionality is primarily for iommu_ops so we can expose to
users which devices need to be grouped because of iommu restrictions.
We can add a quirk to the grouping for this device, but then we have to
figure out how dma_ops makes use of that info too.  Maybe we could have
a 'struct pci_dev *pci_get_iommu_alias_quirk(struct pci_dev *pdev)'
function that given device 0d:00.3 would return 0d:00.0 for this case
and both get_domain_for_dev() and intel_iommu_device_group() could make
use of it.  Thanks,

Alex

