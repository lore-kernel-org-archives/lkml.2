Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2AZSb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:31:29 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:38466
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319Ab2AZSb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:31:28 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I1432N98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYF4S6-02-GYW-02
X-M-MSG: 
Date: Thu, 26 Jan 2012 19:31:16 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Scott Wood <scottwood@freescale.com>
CC: Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120126183116.GI19255@amd.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
 <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
 <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net>
 <20120120160344.GG2205@amd.com>
 <4F219A9C.8000400@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F219A9C.8000400@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 12:25:32PM -0600, Scott Wood wrote:
> On 01/20/2012 10:03 AM, Joerg Roedel wrote:
> > Because the values in this generic geometry-struct make sense for more
> > than one IOMMU (short-term for Tegra GART and Freescale PAMU). If you
> > have additional vendor-specific ones you could add them via a
> > vendor-specific attribute.
> 
> Freescale PAMU is the IOMMU that Varun is talking about, that needs
> additional geometry attributes (in particular, subwindow count).

This can be solved by a PAMU specific attribute.

> How should a PAMU driver interpret "force_aperture"?  When would DMA
> ever be allowed outside the specified range?  What does the range mean
> in that case?

The force_aperture flag indicated whether DMA is only allowed between
aperture_start and apertuer_end or if DMA is allowed outside of this
range too (unmapped in this case).

The AMD GART for example would set this flag to false because it does
not enforce DMA to be in the aperture-range.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

