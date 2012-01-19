Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2ASQHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:07:52 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:3746 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2ASQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:07:50 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY1ZGT-02-L6T-02
X-M-MSG: 
Date: Thu, 19 Jan 2012 17:07:39 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120119160739.GB2205@amd.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
 <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
 <201201191646.13798.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201201191646.13798.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 04:46:13PM +0100, Laurent Pinchart wrote:
> > +struct iommu_domain_geometry {
> > +	u64 aperture_start;	/* First address that can be mapped    */
> > +	u64 aperture_end;	/* Last address that can be mapped     */
> 
> Would it make sense to use a platform-dependent type that represents physical 
> addresses instead of u64 ?

Well, u64 is a catch-all datatype which should suit all drivers. Is this
a problem at ARM? We can also go the more complicated way of introducing
an iova_addr_t or something. But if possible I would like to avoid that.

> > @@ -62,7 +70,8 @@ enum iommu_attr {
> >   * @unmap: unmap a physically contiguous memory region from an iommu
> > domain * @iova_to_phys: translate iova to physical address
> >   * @domain_has_cap: domain capabilities query
> > - * @commit: commit iommu domain
> > + * @domain_get_attr: Query domain attributes
> > + * @domain_set_attr: Change domain attributes
> 
> This belongs to the previous patch.

Right, I change that.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

