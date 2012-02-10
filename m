Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2BJHFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 02:05:32 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:34024 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915Ab2BJHFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 02:05:31 -0500
Message-ID: <4F34C1B6.80201@vmware.com>
Date: Fri, 10 Feb 2012 08:05:26 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Jerome Glisse <jglisse@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jakob Bornecantz <jakob@vmware.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 14/60] drm: remove the second argument of k[un]map_atomic()
References: <1328852421-19678-1-git-send-email-amwang@redhat.com> <1328852421-19678-15-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-15-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>


On 02/10/2012 06:39 AM, Cong Wang wrote:
> Signed-off-by: Cong Wang<amwang@redhat.com>
> ---
>   drivers/gpu/drm/drm_cache.c         |    8 ++++----
>   drivers/gpu/drm/ttm/ttm_tt.c        |   16 ++++++++--------
>   drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c |    6 +++---
>   3 files changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
> index 5928653..4b8653b 100644
> --- a/drivers/gpu/drm/drm_cache.c
> +++ b/drivers/gpu/drm/drm_cache.c
> @@ -41,10 +41,10 @@ drm_clflush_page(struct page *page)
>   	if (unlikely(page == NULL))
>   		return;
>
> -	page_virtual = kmap_atomic(page, KM_USER0);
> +	page_virtual = kmap_atomic(page);
>   	for (i = 0; i<  PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
>   		clflush(page_virtual + i);
> -	kunmap_atomic(page_virtual, KM_USER0);
> +	kunmap_atomic(page_virtual);
>   }
>
>   static void drm_cache_flush_clflush(struct page *pages[],
> @@ -87,10 +87,10 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
>   		if (unlikely(page == NULL))
>   			continue;
>
> -		page_virtual = kmap_atomic(page, KM_USER0);
> +		page_virtual = kmap_atomic(page);
>   		flush_dcache_range((unsigned long)page_virtual,
>   				   (unsigned long)page_virtual + PAGE_SIZE);
> -		kunmap_atomic(page_virtual, KM_USER0);
> +		kunmap_atomic(page_virtual);
>   	}
>   #else
>   	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
> diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
> index 2f75d20..c10cf5e 100644
> --- a/drivers/gpu/drm/ttm/ttm_tt.c
> +++ b/drivers/gpu/drm/ttm/ttm_tt.c
> @@ -309,11 +309,11 @@ int ttm_tt_swapin(struct ttm_tt *ttm)
>   			goto out_err;
>
>   		preempt_disable();
> -		from_virtual = kmap_atomic(from_page, KM_USER0);
> -		to_virtual = kmap_atomic(to_page, KM_USER1);
> +		from_virtual = kmap_atomic(from_page);
> +		to_virtual = kmap_atomic(to_page);
>   		memcpy(to_virtual, from_virtual, PAGE_SIZE);
> -		kunmap_atomic(to_virtual, KM_USER1);
> -		kunmap_atomic(from_virtual, KM_USER0);
> +		kunmap_atomic(to_virtual);
> +		kunmap_atomic(from_virtual);
>   		preempt_enable();
>   		page_cache_release(from_page);
>   	}
> @@ -365,11 +365,11 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistent_swap_storage)
>   			goto out_err;
>   		}
>   		preempt_disable();
> -		from_virtual = kmap_atomic(from_page, KM_USER0);
> -		to_virtual = kmap_atomic(to_page, KM_USER1);
> +		from_virtual = kmap_atomic(from_page);
> +		to_virtual = kmap_atomic(to_page);
>   		memcpy(to_virtual, from_virtual, PAGE_SIZE);
> -		kunmap_atomic(to_virtual, KM_USER1);
> -		kunmap_atomic(from_virtual, KM_USER0);
> +		kunmap_atomic(to_virtual);
> +		kunmap_atomic(from_virtual);
>   		preempt_enable();
>   		set_page_dirty(to_page);
>   		mark_page_accessed(to_page);
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
> index f4e7763..51c9ba5 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
> @@ -136,10 +136,10 @@ static int vmw_gmr_build_descriptors(struct list_head *desc_pages,
>
>   		if (likely(page_virtual != NULL)) {
>   			desc_virtual->ppn = page_to_pfn(page);
> -			kunmap_atomic(page_virtual, KM_USER0);
> +			kunmap_atomic(page_virtual);
>   		}
>
> -		page_virtual = kmap_atomic(page, KM_USER0);
> +		page_virtual = kmap_atomic(page);
>   		desc_virtual = page_virtual - 1;
>   		prev_pfn = ~(0UL);
>
> @@ -169,7 +169,7 @@ static int vmw_gmr_build_descriptors(struct list_head *desc_pages,
>   	}
>
>   	if (likely(page_virtual != NULL))
> -		kunmap_atomic(page_virtual, KM_USER0);
> +		kunmap_atomic(page_virtual);
>
>   	return 0;
>   out_err:

