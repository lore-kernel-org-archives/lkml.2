Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab2K3GQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:16:52 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62304 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2K3GQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:16:51 -0500
Message-ID: <50B84F4E.20809@ozlabs.ru>
Date: Fri, 30 Nov 2012 17:16:46 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
References: <1354138245.1809.226.camel@bling.home>  <1354161225-23118-1-git-send-email-aik@ozlabs.ru> <1354162826.1809.241.camel@bling.home>
In-Reply-To: <1354162826.1809.241.camel@bling.home>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/11/12 15:20, Alex Williamson wrote:

>> +	/* Put tces to the table */
>> +	for (i = 0; (i < pages) && !ret; ++i, tce += IOMMU_PAGE_SIZE) {
>> +		ret = put_tce(tbl, entry + i, tce, direction);
>> +		/*
>> +		 * As IOMMU page size is always 4K, the system page size
>> +		 * can be 64K and there is no special tracking for IOMMU pages,
>> +		 * we only do rlimit check/update for the very first
>> +		 * 4K IOMMUpage within 64K system page.
>> +		 */
>> +		if (!(tce & ~PAGE_MASK))
>> +			++retpages;
>
> Ah, here's the comment I was looking for, though I'm still not sure
> about the read/write bits.
>
> Isn't there an exploit here that a user can lock pages beyond their
> limits if they just skip mapping the first 4k of each page?  Thanks,


Heh. True. Posted another patch with 4K pages per system page usage tracking.



-- 
Alexey
