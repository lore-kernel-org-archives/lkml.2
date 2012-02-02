Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2BBHK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 02:10:29 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:40608 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2BBHK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 02:10:28 -0500
Message-ID: <4F2A362A.3020006@linux.vnet.ibm.com>
Date: Thu, 02 Feb 2012 15:07:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] mm: search from free_area_cache for the bigger size
References: <4F101904.8090405@linux.vnet.ibm.com> <4F1019D3.8020709@linux.vnet.ibm.com> <20120201144401.af84e3a2.akpm@linux-foundation.org>
In-Reply-To: <20120201144401.af84e3a2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12020121-6102-0000-0000-000000C1B59A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 06:44 AM, Andrew Morton wrote:

> On Fri, 13 Jan 2012 19:47:31 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> If the required size is bigger than cached_hole_size, we would better search
>> from free_area_cache, it is more easier to get free region, specifically for
>> the 64 bit process whose address space is large enough
>>
>> Do it just as hugetlb_get_unmapped_area_topdown() in arch/x86/mm/hugetlbpage.c
> 
> Can this cause additional fragmentation of the virtual address region? 
> If so, what might be the implications of this?


Hmm, i think it is not bad since we have cached_hole_size, and, this way is also
used in other functions and architectures(arch_get_unmapped_area,
hugetlb_get_unmapped_area_bottomup, hugetlb_get_unmapped_area_topdown......).

