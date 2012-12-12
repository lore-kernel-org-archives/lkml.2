Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab2LLGUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:20:24 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:59320 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2LLGUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:20:22 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2012 01:20:22 EST
Message-ID: <50C820AF.8050804@ozlabs.ru>
Date: Wed, 12 Dec 2012 17:14:07 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
References: <1354636299.1809.431.camel@bling.home>  <1354865750-8104-1-git-send-email-aik@ozlabs.ru> <1354901926.3224.96.camel@bling.home>
In-Reply-To: <1354901926.3224.96.camel@bling.home>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/12 04:38, Alex Williamson wrote:
>> +static int __init tce_iommu_init(void)
>> +{
>> +	struct pci_dev *pdev = NULL;
>> +	struct iommu_table *tbl;
>> +	struct iommu_group *grp;
>> +
>> +	/* Allocate and initialize IOMMU groups */
>> +	for_each_pci_dev(pdev) {
>> +		tbl = get_iommu_table_base(&pdev->dev);
>> +		if (!tbl)
>> +			continue;
>> +
>> +		/* Skip already initialized */
>> +		if (tbl->it_group)
>> +			continue;
>> +
>> +		grp = iommu_group_alloc();
>> +		if (IS_ERR(grp)) {
>> +			pr_info("tce_vfio: cannot create new IOMMU group, ret=%ld\n",
>> +					PTR_ERR(grp));
>> +			return PTR_ERR(grp);
>> +		}
>> +		tbl->it_group = grp;
>> +		iommu_group_set_iommudata(grp, tbl, group_release);
>
> BTW, groups have a name property that shows up in sysfs that can be set
> with iommu_group_set_name().  IIRC, this was a feature David requested
> for PEs.  It'd be nice if it was used for PEs...  Thanks,



But what would I put there?... IOMMU ID is more than enough at the moment 
and struct iommu_table does not have anything what would have made sense to 
show in the sysfs...


-- 
Alexey
