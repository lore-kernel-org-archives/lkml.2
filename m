Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2A3OYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:24:33 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:15757
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab2A3OYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:24:31 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYM80Q-02-444-02
X-M-MSG: 
Date: Mon, 30 Jan 2012 15:24:24 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Scott Wood <scottwood@freescale.com>
CC: Joerg Roedel <joro@8bytes.org>, Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120130142424.GR19255@amd.com>
References: <20120120160344.GG2205@amd.com>
 <4F219A9C.8000400@freescale.com>
 <20120126183116.GI19255@amd.com>
 <4F219E82.106@freescale.com>
 <20120126185101.GJ19255@amd.com>
 <4F21A2D5.6000204@freescale.com>
 <20120126194428.GH6269@8bytes.org>
 <4F21B152.3010103@freescale.com>
 <20120127110120.GL19255@amd.com>
 <4F2315A3.80909@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F2315A3.80909@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:22:43PM -0600, Scott Wood wrote:

> OK, so there's a geometry that is read-only, and potentially a
> driver-specific geometry that is read/write.  The default config for
> PAMU would likely be a 1 MiB aperture in which the dma api can do
> arbitrary 4k mappings -- this fits within the get generic geometry
> operation.

Better: There is a read-only geometry for _all_ IOMMUs. Some IOMMUs may
also allow to write the geometry, like PAMU.

> Should generic get geometry return an error if the driver-specific
> geometry has been set to something that doesn't fit within the generic
> geometry model?

A domain can only have one geometry. So if you set a new geometry
subsequent calls to get_attr will return the new geometry.

> I said a generic attribute (not GART specific) -- but if we're never
> going to use the generic geometry struct for a set operation, bundling
> it should be OK.

The generic struct should be used to set the geometry. But you can read
out the old geometry and set force_aperture to the same value in the new
geometry. Drivers should actually return -EINVAL when the user tries to
set an unsupported value for force_aperture.

> No, at this point I'm just trying to follow the API development while
> tending to other tasks.  I think Varun is working on the code for now.

Okay, maybe it is better to follow a 'release early, release often'
model here. So we can work out the issues together.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

