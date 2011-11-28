Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1K1OQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:16:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1K1OQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:16:01 -0500
Date: Mon, 28 Nov 2011 15:16:00 +0100
From: Jan Kara <jack@suse.cz>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 48/62] udf: remove the second argument of
 k[un]map_atomic()
Message-ID: <20111128141600.GC6366@quack.suse.cz>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
 <1322371662-26166-49-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322371662-26166-49-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 27-11-11 13:27:28, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>
  Acked-by: Jan Kara <jack@suse.cz>

										Honza

> ---
>  fs/udf/file.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index d8ffa7c..95b8d91 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -87,10 +87,10 @@ static int udf_adinicb_write_end(struct file *file,
>  	char *kaddr;
>  	struct udf_inode_info *iinfo = UDF_I(inode);
>  
> -	kaddr = kmap_atomic(page, KM_USER0);
> +	kaddr = kmap_atomic(page);
>  	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + offset,
>  		kaddr + offset, copied);
> -	kunmap_atomic(kaddr, KM_USER0);
> +	kunmap_atomic(kaddr);
>  
>  	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
>  }
> -- 
> 1.7.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
