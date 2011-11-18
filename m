Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1KRKrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:47:52 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:8553
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab1KRKru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:47:50 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LUURA5-01-53B-02
X-M-MSG: 
Date: Fri, 18 Nov 2011 11:46:51 +0100
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <iommu@lists.linux-foundation.org>, <dwmw2@infradead.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu: Include MSI susceptibility to DMA in creating
 iommu groups
Message-ID: <20111118104651.GJ5627@amd.com>
References: <20111117170800.3125.84150.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111117170800.3125.84150.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 10:09:26AM -0700, Alex Williamson wrote:
> IOMMU drivers should account for the platform's susceptibility to
> DMA triggered MSI interrupts in creating IOMMU groups.  Skip
> devices when the IOMMU can't isolate MSI from DMA, but allow
> an iommu=group_unsafe_msi option for opt-in.  This removes the
> leap in logic for users that IOMMU_CAP_INTR_REMAP is required for
> interrupt security when they may be running on a non-x86 platform
> that does not have this dependency.

I actually don't see the point in this. The iommu-group thing is to tell
user-space what devices the IOMMU can safely distinguish between. The
absence of interrupt-remapping changes nothing to that grouping. So why
remove it when interrupt remapping is not enabled?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

