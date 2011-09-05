Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1IEKBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 06:01:14 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:58574
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab1IEKBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 06:01:02 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz98dKzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR1NTH-01-3XV-02
X-M-MSG: 
Date: Mon, 5 Sep 2011 12:00:53 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 6/7] iommu/core: add fault reporting
Message-ID: <20110905100053.GP16691@amd.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
 <1314984756-4400-7-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314984756-4400-7-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 01:32:35PM -0400, Ohad Ben-Cohen wrote:
> -struct iommu_domain *iommu_domain_alloc(void)
> +/**
> + * iommu_domain_alloc() - allocate and initialize a new iommu domain
> + * @handler: an optional pointer to a fault handler, or NULL if not needed
> + *
> + * Returns the new domain, or NULL on error.
> + */
> +struct iommu_domain *iommu_domain_alloc(iommu_fault_handler_t handler)

Please add a seperate function for setting the fault-handler. It is
optional, so no need to be a value of the alloc-function.

> +/**
> + * enum iommu_fault_types - iommu fault types
> + *
> + * @IOMMU_ERROR: Unrecoverable error
> + * @IOMMU_TLBMISS: TLB miss while the page table walker is disabled
> + * @IOMMU_NOPTE: TLB miss and no PTE for the requested address
> + */
> +enum iommu_fault_types {
> +	IOMMU_ERROR,
> +	IOMMU_TLBMISS,
> +	IOMMU_NOPTE,
> +};

Can you elaborate a bit on what the user of the api will do different
between IOMMU_TLBMISS and IOMMU_NOPTE?
My feeling is that those differences should be handled internally in the
IOMMU driver, but probably I miss a use-case.
Also, we need some flags to distinguish between the type of the fault
(read, write, ...).

	Joerg


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

