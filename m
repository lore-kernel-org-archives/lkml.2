Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1LAUSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:18:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55302 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1LAUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:18:53 -0500
Date: Thu, 1 Dec 2011 12:18:46 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 44/62] ocfs2: remove the second argument of
 k[un]map_atomic()
Message-ID: <20111201201846.GF1495@noexit.corp.google.com>
Mail-Followup-To: Cong Wang <amwang@redhat.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
 <1322371662-26166-45-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322371662-26166-45-git-send-email-amwang@redhat.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 01:27:24PM +0800, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: Joel Becker <jlbec@evilplan.org>

I'm presuming you'll handle pushing this with the entire series.

Joel

> ---
>  fs/ocfs2/aops.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index c1efe93..61f93a5 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -102,7 +102,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>  		 * copy, the data is still good. */
>  		if (buffer_jbd(buffer_cache_bh)
>  		    && ocfs2_inode_is_new(inode)) {
> -			kaddr = kmap_atomic(bh_result->b_page, KM_USER0);
> +			kaddr = kmap_atomic(bh_result->b_page);
>  			if (!kaddr) {
>  				mlog(ML_ERROR, "couldn't kmap!\n");
>  				goto bail;
> @@ -110,7 +110,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>  			memcpy(kaddr + (bh_result->b_size * iblock),
>  			       buffer_cache_bh->b_data,
>  			       bh_result->b_size);
> -			kunmap_atomic(kaddr, KM_USER0);
> +			kunmap_atomic(kaddr);
>  			set_buffer_uptodate(bh_result);
>  		}
>  		brelse(buffer_cache_bh);
> @@ -236,13 +236,13 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
>  		return -EROFS;
>  	}
>  
> -	kaddr = kmap_atomic(page, KM_USER0);
> +	kaddr = kmap_atomic(page);
>  	if (size)
>  		memcpy(kaddr, di->id2.i_data.id_data, size);
>  	/* Clear the remaining part of the page */
>  	memset(kaddr + size, 0, PAGE_CACHE_SIZE - size);
>  	flush_dcache_page(page);
> -	kunmap_atomic(kaddr, KM_USER0);
> +	kunmap_atomic(kaddr);
>  
>  	SetPageUptodate(page);
>  
> @@ -671,7 +671,7 @@ static void ocfs2_clear_page_regions(struct page *page,
>  
>  	ocfs2_figure_cluster_boundaries(osb, cpos, &cluster_start, &cluster_end);
>  
> -	kaddr = kmap_atomic(page, KM_USER0);
> +	kaddr = kmap_atomic(page);
>  
>  	if (from || to) {
>  		if (from > cluster_start)
> @@ -682,7 +682,7 @@ static void ocfs2_clear_page_regions(struct page *page,
>  		memset(kaddr + cluster_start, 0, cluster_end - cluster_start);
>  	}
>  
> -	kunmap_atomic(kaddr, KM_USER0);
> +	kunmap_atomic(kaddr);
>  }
>  
>  /*
> @@ -1928,9 +1928,9 @@ static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
>  		}
>  	}
>  
> -	kaddr = kmap_atomic(wc->w_target_page, KM_USER0);
> +	kaddr = kmap_atomic(wc->w_target_page);
>  	memcpy(di->id2.i_data.id_data + pos, kaddr + pos, *copied);
> -	kunmap_atomic(kaddr, KM_USER0);
> +	kunmap_atomic(kaddr);
>  
>  	trace_ocfs2_write_end_inline(
>  	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> -- 
> 1.7.4.4
> 

-- 

Life's Little Instruction Book #94

	"Make it a habit to do nice things for people who 
	 will never find out."

			http://www.jlbec.org/
			jlbec@evilplan.org
