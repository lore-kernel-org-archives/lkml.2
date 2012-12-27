Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab2L0GCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 01:02:11 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:32534 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab2L0GCJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:02:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz9371I542I1432Id799hzz1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 0/4] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Topic: [PATCH 0/4] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Index: AQHN2gLne8kVG5guWUGJo+hhwCHhgJgihVZggAm1voA=
Date: Thu, 27 Dec 2012 06:02:00 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D2EEFD3@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1355493114-21776-1-git-send-email-Varun.Sethi@freescale.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.15]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
Do you have any comments on the patchset?

Regards
Varun

> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Friday, December 21, 2012 7:17 AM
> To: 'Joerg Roedel'
> Cc: Sethi Varun-B16395; joerg.roedel@amd.com; iommu@lists.linux-
> foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; Tabi Timur-B04825; Wood Scott-B07421
> Subject: RE: [PATCH 0/4] iommu/fsl: Freescale PAMU driver and IOMMU API
> implementation.
> 
> ping!!
> 
> > -----Original Message-----
> > From: Sethi Varun-B16395
> > Sent: Friday, December 14, 2012 7:22 PM
> > To: joerg.roedel@amd.com; iommu@lists.linux-foundation.org; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Tabi Timur-B04825;
> > Wood Scott-B07421
> > Cc: Sethi Varun-B16395
> > Subject: [PATCH 0/4] iommu/fsl: Freescale PAMU driver and IOMMU API
> > implementation.
> >
> > This patchset provides the Freescale PAMU (Peripheral Access
> > Management
> > Unit) driver and the corresponding IOMMU API implementation. PAMU is
> > the IOMMU present on Freescale QorIQ platforms. PAMU can authorize
> > memory access, remap the memory address, and remap the I/O transaction
> type.
> >
> > This set consists of the following patches:
> > 1. Addition of new field in the device (powerpc) archdata structure
> > for storing iommu domain information
> >    pointer. This pointer is stored when the device is attached to a
> > particular iommu domain.
> > 2. Add PAMU bypass enable register to the ccsr_guts structure.
> > 3. Addition of domain attributes required by the PAMU driver IOMMU API.
> > 4. PAMU driver and IOMMU API implementation.
> >
> > This patch set is based on the next branch of the iommu git tree
> > maintained by Joerg.
> >
> > Varun Sethi (4):
> >   store iommu domain info in device arch data.
> >   add pamu bypass enable register to guts.
> >   Add iommu attributes for PAMU
> >   FSL PAMU driver.
> >
> >  arch/powerpc/include/asm/device.h   |    4 +
> >  arch/powerpc/include/asm/fsl_guts.h |    4 +-
> >  drivers/iommu/Kconfig               |    8 +
> >  drivers/iommu/Makefile              |    1 +
> >  drivers/iommu/fsl_pamu.c            | 1152
> > +++++++++++++++++++++++++++++++++++
> >  drivers/iommu/fsl_pamu.h            |  398 ++++++++++++
> >  drivers/iommu/fsl_pamu_domain.c     | 1033
> > +++++++++++++++++++++++++++++++
> >  drivers/iommu/fsl_pamu_domain.h     |   96 +++
> >  include/linux/iommu.h               |   49 ++
> >  9 files changed, 2744 insertions(+), 1 deletions(-)  create mode
> > 100644 drivers/iommu/fsl_pamu.c  create mode 100644
> > drivers/iommu/fsl_pamu.h create mode 100644
> > drivers/iommu/fsl_pamu_domain.c  create mode 100644
> > drivers/iommu/fsl_pamu_domain.h
> >
> > --
> > 1.7.4.1


