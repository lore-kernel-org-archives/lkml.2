Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2LDMLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:11:16 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:21958
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab2LDMLM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:11:12 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551biz98dI9371I542I1432Izz1de0h1202h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 4/4 v6] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Topic: [PATCH 4/4 v6] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Index: AQHNz7bIAZUeEC7LwE6AUtAtq2ZgbpgHgvCAgAEJn5A=
Date: Tue, 4 Dec 2012 12:11:06 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D2B715D@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1354360921-20850-1-git-send-email-Varun.Sethi@freescale.com>
 <50BD056F.7070701@freescale.com>
In-Reply-To: <50BD056F.7070701@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.77]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tabi Timur-B04825
> Sent: Tuesday, December 04, 2012 1:33 AM
> To: Sethi Varun-B16395
> Cc: joerg.roedel@amd.com; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood Scott-B07421
> Subject: Re: [PATCH 4/4 v6] iommu/fsl: Freescale PAMU driver and IOMMU
> API implementation.
> 
> Varun Sethi wrote:
> 
> > +	out_be32(&pamu_regs->ppbah, ((u64)ppaact_phys) >> 32);
> > +	out_be32(&pamu_regs->ppbal, ppaact_phys);
> > +	ppaact_phys = ppaact_phys + PAACT_SIZE;
> > +	out_be32(&pamu_regs->pplah, ((u64)ppaact_phys) >> 32);
> > +	out_be32(&pamu_regs->pplal, ppaact_phys);
> 
> Instead of  ((u64)ppaact_phys) >> 32, use upper_32_bits() and
> lower_32_bits().
> 
> > +#define PAACE_NUMBER_ENTRIES    0xFF
> 
> This is going to break with large LIODNs.  Instead of hard-coding the
> size of the PPAACT, you need to scan the device tree for the largest
> LIODN, and make the array dynamically sized.
This would in any case change with the new LIODN allocation scheme. I intend on introducing the new scheme as a separate patch.

-Varun

