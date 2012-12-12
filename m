Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2LLOfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:35:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab2LLOe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:34:59 -0500
Message-ID: <1355322875.3224.201.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Date: Wed, 12 Dec 2012 07:34:35 -0700
In-Reply-To: <50C820AF.8050804@ozlabs.ru>
References: <1354636299.1809.431.camel@bling.home>
	  <1354865750-8104-1-git-send-email-aik@ozlabs.ru>
	 <1354901926.3224.96.camel@bling.home> <50C820AF.8050804@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 17:14 +1100, Alexey Kardashevskiy wrote:
> On 08/12/12 04:38, Alex Williamson wrote:
> >> +static int __init tce_iommu_init(void)
> >> +{
> >> +	struct pci_dev *pdev = NULL;
> >> +	struct iommu_table *tbl;
> >> +	struct iommu_group *grp;
> >> +
> >> +	/* Allocate and initialize IOMMU groups */
> >> +	for_each_pci_dev(pdev) {
> >> +		tbl = get_iommu_table_base(&pdev->dev);
> >> +		if (!tbl)
> >> +			continue;
> >> +
> >> +		/* Skip already initialized */
> >> +		if (tbl->it_group)
> >> +			continue;
> >> +
> >> +		grp = iommu_group_alloc();
> >> +		if (IS_ERR(grp)) {
> >> +			pr_info("tce_vfio: cannot create new IOMMU group, ret=%ld\n",
> >> +					PTR_ERR(grp));
> >> +			return PTR_ERR(grp);
> >> +		}
> >> +		tbl->it_group = grp;
> >> +		iommu_group_set_iommudata(grp, tbl, group_release);
> >
> > BTW, groups have a name property that shows up in sysfs that can be set
> > with iommu_group_set_name().  IIRC, this was a feature David requested
> > for PEs.  It'd be nice if it was used for PEs...  Thanks,
> 
> 
> 
> But what would I put there?... IOMMU ID is more than enough at the moment 
> and struct iommu_table does not have anything what would have made sense to 
> show in the sysfs...

I believe David mentioned that PEs had user visible names.  Perhaps they
match an enclosure location or something.  Group numbers are rather
arbitrary and really have no guarantee of persistence.  Thanks,

Alex


