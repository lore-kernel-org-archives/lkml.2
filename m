Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0G2Ihu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:37:50 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22097 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0G2Ihr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:37:47 -0400
X-SpamScore: -33
X-BigFish: VPS-33(zz1432N9370J98dN1447Rzz1202hzz15d4Rz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6B9AO-02-2OA-02
X-M-MSG: 
Date: Thu, 29 Jul 2010 10:40:19 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100729084018.GM26098@amd.com>
References: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
 <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org>
 <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
 <201007291026.55928.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201007291026.55928.arnd@arndb.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 04:26:55AM -0400, Arnd Bergmann wrote:
> On Thursday 29 July 2010 05:35:48 FUJITA Tomonori wrote:
> > > 
> > > From what I have been able to tell, the IOMMU interface was written by
> > > AMD/Intel to allow the kvm code to work with a common IOMMU interface. To
> > 
> > Don't confuse the IOMMU interface with the DMA API that Arnd
> > mentioned.
> > 
> > They are not related at all.

Thats not 100% true. They are not strictly related, but they are related
as they may use the same backend kernel drivers to provide their
functionality. Both APIs exist for different purposes, of course.

> Exactly, thanks for the clarification. I also didn't realize that there
> is now an include/linux/iommu.h file that only describes the PCI SR-IOV
> interfaces, unlike the generic IOMMU support that we have in your
> include/linux/dma-mapping.h file.

The IOMMU-API is not about SR-IOV. It is about the capabilities of
modern IOMMU hardware that we can not provide to the kernel with the
DMA-API such as the ability to choose ourself at which io-virtual
address a given cpu physical address should be mapped.
Also I wouldn't call the DMA-API an IOMMU interface. The API does not
depend on an IOMMU which is an important difference to the IOMMU-API.
The IOMMU-API is probably not generic enough to handle all kinds of
IOMMUs but its closer to a generic IOMMU-API than the DMA-API.

		Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

