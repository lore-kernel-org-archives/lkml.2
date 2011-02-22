Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1BVRLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:11:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:48800 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab1BVRLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:11:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,207,1297065600"; 
   d="scan'208";a="711813131"
Message-ID: <4D63EE38.9000008@linux.intel.com>
Date: Tue, 22 Feb 2011 09:11:20 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        lwoodman@redhat.com
Subject: Re: [PATCH 1/8] Fix interleaving for transparent hugepages
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-2-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1102220933500.16060@router.home>
In-Reply-To: <alpine.DEB.2.00.1102220933500.16060@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2011 7:34 AM, Christoph Lameter wrote:
> On Mon, 21 Feb 2011, Andi Kleen wrote:
>
>> @@ -1830,7 +1830,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
>>   	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
>>   		unsigned nid;
>>
>> -		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
>> +		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT<<  order);
> Should be PAGE_SHIFT + order.

Oops. True. Thanks.

-Andi

