Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2I0LCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:02:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49316 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2I0LCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:02:10 -0400
Date: Thu, 27 Sep 2012 13:02:05 +0200
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [RFC v9 PATCH 00/21] memory-hotplug: hot-remove physical memory
Message-ID: <20120927110205.GB30772@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
 <20120926165820.GB7559@dhcp-192-168-178-175.profitbricks.localdomain>
 <50642526.4070603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50642526.4070603@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 06:06:30PM +0800, Wen Congyang wrote:
> Please try the following patch:
> From a38ec678e0a9b48b252f457d7910b7527049dc43 Mon Sep 17 00:00:00 2001
> From: Wen Congyang <wency@cn.fujitsu.com>
> Date: Thu, 27 Sep 2012 17:27:57 +0800
> Subject: [PATCH] clear the memory to store page information

this solves the hot re-add problem for me.
thanks for the quick solution.

- Vasilis

> 
> ---
>  mm/sparse.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index ab9d755..36dda08 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -639,7 +639,6 @@ static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
>  got_map_page:
>  	ret = (struct page *)pfn_to_kaddr(page_to_pfn(page));
>  got_map_ptr:
> -	memset(ret, 0, memmap_size);
>  
>  	return ret;
>  }
> @@ -761,6 +760,8 @@ int __meminit sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
>  		goto out;
>  	}
>  
> +	memset(memmap, 0, sizeof(struct page) * nr_pages);
> +
>  	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>  
>  	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
> -- 
> 1.7.1
> 
> Thanks
> Wen Congyang
> 
> > 
> > thanks,
> > 
> > - Vasilis
> > 
> > [1] https://lkml.org/lkml/2012/9/6/635
> > [2] https://lkml.org/lkml/2012/9/11/542
> > [3] https://lkml.org/lkml/2012/9/20/37
> > [4] http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/98691
> > 
> > 
> > 
> 
