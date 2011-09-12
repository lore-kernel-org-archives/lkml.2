Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1ILMiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:38:22 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:56307
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771Ab1ILMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:38:20 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRETQB-02-BB7-02
X-M-MSG: 
Date: Mon, 12 Sep 2011 14:37:25 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] iommu/core: Add bus_type parameter to
 iommu_domain_alloc
Message-ID: <20110912123725.GB11701@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-4-git-send-email-joerg.roedel@amd.com>
 <F1FD01C1EFCE15408DBF59462450B3BD1C463D@039-SN1MPN1-006.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <F1FD01C1EFCE15408DBF59462450B3BD1C463D@039-SN1MPN1-006.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 07:50:35AM -0400, Sethi Varun-B16395 wrote:
> > -	kvm->arch.iommu_domain = iommu_domain_alloc();
> > +	kvm->arch.iommu_domain = iommu_domain_alloc(&pci_bus_type);
> 
> Although it might require changes starting all the way from the qemu interface, but
> it would certainly be nice if this could be made more extendable/generic in terms
> of the bus_type usage. This interface would be used by us (Freescale )for direct
> assignment of SOC devices sitting on the platform bus.

Yeah, you are right on this one. Alex is working on a better and more
generic solution for kvm device passthrough (vfio). This patch only
changes the existing code which is pci-only, though.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

