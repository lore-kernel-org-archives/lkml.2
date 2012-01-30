Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2A3ObM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:31:12 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:17106 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753167Ab2A3ObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:31:10 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYM8BS-02-06O-02
X-M-MSG: 
Date: Mon, 30 Jan 2012 15:30:10 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120130143010.GS19255@amd.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
 <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
 <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net>
 <20120120160344.GG2205@amd.com>
 <4F219A9C.8000400@freescale.com>
 <20120126183116.GI19255@amd.com>
 <4F219E82.106@freescale.com>
 <20120126185101.GJ19255@amd.com>
 <C5ECD7A89D1DC44195F34B25E172658D041E81@039-SN2MPN1-012.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D041E81@039-SN2MPN1-012.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 06:27:30AM +0000, Sethi Varun-B16395 wrote:

> Can you please explain how would IOMMU remapping be used, based on the
> force_aperture flag.

If force_aperture is flase the dma-api code needs to check if remapping
is required at all. It performs the following checks:

	* Does the physical address of the buffer not overlap with the
	  aperture?
	* Fits the buffer into the device's dma address mask?

If both questions are answered with yes no remapping is required and
dma-api just returns the physical address. Otherwise it calls into the
dma-api to create a mapping.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

