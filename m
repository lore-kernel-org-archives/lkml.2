Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2ASQ1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:27:13 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:58723 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2ASQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:27:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Thu, 19 Jan 2012 17:27:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.4; x86_64; ; )
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Ohad Ben-Cohen" <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com> <201201191646.13798.laurent.pinchart@ideasonboard.com> <20120119160739.GB2205@amd.com>
In-Reply-To: <20120119160739.GB2205@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201191727.10176.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Thursday 19 January 2012 17:07:39 Joerg Roedel wrote:
> On Thu, Jan 19, 2012 at 04:46:13PM +0100, Laurent Pinchart wrote:
> > > +struct iommu_domain_geometry {
> > > +	u64 aperture_start;	/* First address that can be mapped    */
> > > +	u64 aperture_end;	/* Last address that can be mapped     */
> > 
> > Would it make sense to use a platform-dependent type that represents
> > physical addresses instead of u64 ?
> 
> Well, u64 is a catch-all datatype which should suit all drivers. Is this
> a problem at ARM?

No, it's not a problem for ARM, at least to my knowledge. It just struck me as 
weird, as we have specific data types for other kinds of addresses (such as 
dma_addr_t).

> We can also go the more complicated way of introducing an iova_addr_t or
> something. But if possible I would like to avoid that.
> 
> > > @@ -62,7 +70,8 @@ enum iommu_attr {
> > > 
> > >   * @unmap: unmap a physically contiguous memory region from an iommu
> > > 
> > > domain * @iova_to_phys: translate iova to physical address
> > > 
> > >   * @domain_has_cap: domain capabilities query
> > > 
> > > - * @commit: commit iommu domain
> > > + * @domain_get_attr: Query domain attributes
> > > + * @domain_set_attr: Change domain attributes
> > 
> > This belongs to the previous patch.
> 
> Right, I change that.

-- 
Regards,

Laurent Pinchart
