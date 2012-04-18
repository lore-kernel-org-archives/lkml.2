Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2DRF6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:58:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48445 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2DRF6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:58:36 -0400
Message-ID: <4F8E5807.6080909@openvz.org>
Date: Wed, 18 Apr 2012 09:58:31 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH linux-next] mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma
References: <20120417122819.7438.26117.stgit@zurg> <20120417135726.05de2546.akpm@linux-foundation.org>
In-Reply-To: <20120417135726.05de2546.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 17 Apr 2012 16:28:19 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> This patch fixes gcc warning (and bug?) introduced in linux-next commit cc9a6c877
>> ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
>>
>> Local variable "page" can be uninitialized if nodemask from vma policy does not
>> intersects with nodemask from cpuset. Even if it wouldn't happens it's better to
>> initialize this variable explicitly than to introduce kernel oops on weird corner case.
>>
>> mm/hugetlb.c: In function ___alloc_huge_page___:
>> mm/hugetlb.c:1135:5: warning: ___page___ may be used uninitialized in this function
>>
>> ...
>>
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -532,7 +532,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
>>   				struct vm_area_struct *vma,
>>   				unsigned long address, int avoid_reserve)
>>   {
>> -	struct page *page;
>> +	struct page *page = NULL;
>>   	struct mempolicy *mpol;
>>   	nodemask_t *nodemask;
>>   	struct zonelist *zonelist;
>
> hm, that's a pretty blatant use-uninitialised bug.  I wonder why so few
> gcc versions report it.  Mine doesn't.

I'm using latest gcc-4.7

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

