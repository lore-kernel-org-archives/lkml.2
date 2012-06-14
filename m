Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2FNDLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:11:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55120 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2FNDLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:11:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD955E8.5050100@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 12:09:28 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 05/15] hugetlb: avoid taking i_mmap_mutex in unmap_single_vma()
 for hugetlb
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1339583254-895-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 19:27), Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
> 
> i_mmap_mutex lock was added in unmap_single_vma by 502717f4e ("hugetlb:
> fix linked list corruption in unmap_hugepage_range()") but we don't use
> page->lru in unmap_hugepage_range any more.  Also the lock was taken
> higher up in the stack in some code path.  That would result in deadlock.
> 
> unmap_mapping_range (i_mmap_mutex)
>   ->  unmap_mapping_range_tree
>      ->  unmap_mapping_range_vma
>         ->  zap_page_range_single
>           ->  unmap_single_vma
> 	      ->  unmap_hugepage_range (i_mmap_mutex)
> 
> For shared pagetable support for huge pages, since pagetable pages are ref
> counted we don't need any lock during huge_pmd_unshare.  We do take
> i_mmap_mutex in huge_pmd_share while walking the vma_prio_tree in mapping.
> (39dde65c9940c97f ("shared page table for hugetlb page")).
> 
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>


