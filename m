Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2ATFok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 00:44:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1986 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2ATFoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 00:44:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Jan 2012 21:44:18 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "b08248@gmail.com" <b08248@gmail.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>
Date: Fri, 20 Jan 2012 06:44:09 +0100
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Topic: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Index: AczXNouqin9mBDvnRtuafQLsPqoWUQ==
Message-ID: <20120120.074409.1835198567920956646.hdoyu@nvidia.com>
References: <201201191646.13798.laurent.pinchart@ideasonboard.com><20120119160739.GB2205@amd.com><201201191727.10176.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201191727.10176.laurent.pinchart@ideasonboard.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Thu, 19 Jan 2012 17:27:09 +0100
Message-ID: <201201191727.10176.laurent.pinchart@ideasonboard.com>

> Hi Joerg,
> 
> On Thursday 19 January 2012 17:07:39 Joerg Roedel wrote:
> > On Thu, Jan 19, 2012 at 04:46:13PM +0100, Laurent Pinchart wrote:
> > > > +struct iommu_domain_geometry {
> > > > +	u64 aperture_start;	/* First address that can be mapped    */
> > > > +	u64 aperture_end;	/* Last address that can be mapped     */
> > > 
> > > Would it make sense to use a platform-dependent type that represents
> > > physical addresses instead of u64 ?
> > 
> > Well, u64 is a catch-all datatype which should suit all drivers. Is this
> > a problem at ARM?
> 
> No, it's not a problem for ARM, at least to my knowledge. It just struck me as 
> weird, as we have specific data types for other kinds of addresses (such as 
> dma_addr_t).
> 
> > We can also go the more complicated way of introducing an iova_addr_t or
> > something. But if possible I would like to avoid that.

"dma_addr_t" sounds nicer(and makes still sense) to me than a new "iova_addr_t".
