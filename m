Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1LAXOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:14:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:51984 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab1LAXOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:14:33 -0500
Message-ID: <1322781257.10893.38.camel@i7.infradead.org>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Gibson <dwg@au1.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Date: Thu, 01 Dec 2011 23:14:17 +0000
In-Reply-To: <1322750048.26545.101.camel@bling.home>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
	 <20111201000337.GA5427@truffala.fritz.box>
	 <1322722110.26545.68.camel@bling.home>
	 <1322735610.24294.9.camel@i7.infradead.org>
	 <1322750048.26545.101.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 07:34 -0700, Alex Williamson wrote:
> > Btw, did we get a quirk for the Ricoh multi-function devices which all
> > need to be in the same group because they do all their DMA from function
> > zero? I think we need another similar quirk for a Marvell SATA
> > controller which seems to do its AHCI DMA from its IDE function; see
> > https://bugzilla.redhat.com/757166
> 
> No, as I mentioned, groups are currently for iommu_ops, not dma_ops,

That doesn't matter. There are multiple devices which do all their DMA
from the same source-id, and which have to be handled together. It
doesn't *matter* that it's a hardware bug in this case, and it's just
because they're multiple PCI devices behind a PCIe bridge in the other
case. The grouping code needs to handle it, whether it's for the benefit
of iommu_ops, dma_ops, or both.

> though it makes sense that iommu drivers could use the group info or
> create common quirk infrastructure for handling broken devices like
> these. 

Well, I think we mostly have a consensus that dma_ops should be
implemented *using* iommu_ops; I'd rather be trying to make things
*consistent* between the two rather than building up the differences.

So I'd definitely go for your "use the group info" option. It is the
*same* info, and needs the *same* quirks.

-- 
dwmw2

