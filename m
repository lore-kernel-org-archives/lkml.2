Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1K0LgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:36:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58505 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab1K0LgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:36:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cong Wang <amwang@redhat.com>
Subject: Re: [PATCH 50/62] power: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 12:38:53 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-51-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-51-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111271238.53544.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 27, 2011, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  kernel/power/snapshot.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index cbe2c14..8018450 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -993,20 +993,20 @@ static void copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
>  	s_page = pfn_to_page(src_pfn);
>  	d_page = pfn_to_page(dst_pfn);
>  	if (PageHighMem(s_page)) {
> -		src = kmap_atomic(s_page, KM_USER0);
> -		dst = kmap_atomic(d_page, KM_USER1);
> +		src = kmap_atomic(s_page);
> +		dst = kmap_atomic(d_page);
>  		do_copy_page(dst, src);
> -		kunmap_atomic(dst, KM_USER1);
> -		kunmap_atomic(src, KM_USER0);
> +		kunmap_atomic(dst);
> +		kunmap_atomic(src);
>  	} else {
>  		if (PageHighMem(d_page)) {
>  			/* Page pointed to by src may contain some kernel
>  			 * data modified by kmap_atomic()
>  			 */
>  			safe_copy_page(buffer, s_page);
> -			dst = kmap_atomic(d_page, KM_USER0);
> +			dst = kmap_atomic(d_page);
>  			copy_page(dst, buffer);
> -			kunmap_atomic(dst, KM_USER0);
> +			kunmap_atomic(dst);
>  		} else {
>  			safe_copy_page(page_address(d_page), s_page);
>  		}
> @@ -1721,9 +1721,9 @@ int snapshot_read_next(struct snapshot_handle *handle)
>  			 */
>  			void *kaddr;
>  
> -			kaddr = kmap_atomic(page, KM_USER0);
> +			kaddr = kmap_atomic(page);
>  			copy_page(buffer, kaddr);
> -			kunmap_atomic(kaddr, KM_USER0);
> +			kunmap_atomic(kaddr);
>  			handle->buffer = buffer;
>  		} else {
>  			handle->buffer = page_address(page);
> @@ -2007,9 +2007,9 @@ static void copy_last_highmem_page(void)
>  	if (last_highmem_page) {
>  		void *dst;
>  
> -		dst = kmap_atomic(last_highmem_page, KM_USER0);
> +		dst = kmap_atomic(last_highmem_page);
>  		copy_page(dst, buffer);
> -		kunmap_atomic(dst, KM_USER0);
> +		kunmap_atomic(dst);
>  		last_highmem_page = NULL;
>  	}
>  }
> @@ -2302,13 +2302,13 @@ swap_two_pages_data(struct page *p1, struct page *p2, void *buf)
>  {
>  	void *kaddr1, *kaddr2;
>  
> -	kaddr1 = kmap_atomic(p1, KM_USER0);
> -	kaddr2 = kmap_atomic(p2, KM_USER1);
> +	kaddr1 = kmap_atomic(p1);
> +	kaddr2 = kmap_atomic(p2);
>  	copy_page(buf, kaddr1);
>  	copy_page(kaddr1, kaddr2);
>  	copy_page(kaddr2, buf);
> -	kunmap_atomic(kaddr2, KM_USER1);
> -	kunmap_atomic(kaddr1, KM_USER0);
> +	kunmap_atomic(kaddr2);
> +	kunmap_atomic(kaddr1);
>  }
>  
>  /**
> 

