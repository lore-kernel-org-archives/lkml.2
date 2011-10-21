Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1JUVRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:17:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1JUVRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:17:06 -0400
Subject: Re: [PATCH 0/4] iommu: iommu_ops group interface
From: Alex Williamson <alex.williamson@redhat.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chrisw@redhat.com" <chrisw@redhat.com>,
        "agraf@suse.de" <agraf@suse.de>, "dwg@au1.ibm.com" <dwg@au1.ibm.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "B08248@freescale.com" <B08248@freescale.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Date: Fri, 21 Oct 2011 15:16:34 -0600
In-Reply-To: <1319229248.19448.6.camel@shinybook.infradead.org>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <1319229248.19448.6.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1319231795.19108.22.camel@bling.home>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-21 at 20:34 +0000, Woodhouse, David wrote:
> On Fri, 2011-10-21 at 13:55 -0600, Alex Williamson wrote:
> > IOMMUs can't always distiguish transactions from each individual
> > device in a system.  Sometimes this is by design (such as powerpc
> > partitionable endpoints), other times by topology (PCIe-to-PCI
> > bridges masking downstream devices).  We call these sets of
> > indistinguishable devices "groups". 
> 
> Other times it's because a multi-function PCIe device is broken and does
> all its DMA from function zero.... like some Ricoh devices seen in
> laptops. Can you handle quirks to "group" those too?

I could add:

drivers/pci/quirks.c: int pci_iommu_group_mf_quirk(struct pci_dev *)

That's used just like iommu_group_mf to always blacklist specific
devices.  Let me know VID/DID if you have them.  Thanks,

Alex

