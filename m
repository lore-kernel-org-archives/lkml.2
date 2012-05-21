Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab2EUWAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:00:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54351 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2EUWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:00:43 -0400
Message-ID: <4FBABB30.9090300@jp.fujitsu.com>
Date: Mon, 21 May 2012 18:01:20 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: dave@linux.vnet.ibm.com
CC: cl@linux.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com,
        rientjes@google.com, adobriyan@gmail.com, akpm@linux-foundation.org,
        mel@csn.ul.ie
Subject: Re: [PATCH] hugetlb: fix resv_map leak in error path
References: <20120521202814.E01F0FE1@kernel>
In-Reply-To: <20120521202814.E01F0FE1@kernel>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2012 4:28 PM, Dave Hansen wrote:
> When called for anonymous (non-shared) mappings,
> hugetlb_reserve_pages() does a resv_map_alloc().  It depends on
> code in hugetlbfs's vm_ops->close() to release that allocation.
> 
> However, in the mmap() failure path, we do a plain unmap_region()
> without the remove_vma() which actually calls vm_ops->close().
> 
> This is a decent fix.  This leak could get reintroduced if
> new code (say, after hugetlb_reserve_pages() in
> hugetlbfs_file_mmap()) decides to return an error.  But, I think
> it would have to unroll the reservation anyway.
> 
> This hasn't been extensively tested.  Pretty much compile and
> boot tested along with Christoph's test case:
> 
> 	http://marc.info/?l=linux-mm&m=133728900729735
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> ecked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

typo. ;-)

> Reported/tested-by: Christoph Lameter <cl@linux.com>

