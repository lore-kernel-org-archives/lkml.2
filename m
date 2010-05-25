Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab0E0Pxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:53:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0E0Px2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:53:28 -0400
Date: Tue, 25 May 2010 16:06:46 +0200
From: Jan Kara <jack@suse.cz>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv4 14/17] UDF: do not manipulate s_dirt directly
Message-ID: <20100525140646.GC3783@quack.suse.cz>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-15-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274795352-3551-15-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 25-05-10 16:49:09, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> ... use new VFS helpers instead.
  Looks. OK. You can add
Acked-by: Jan Kara <jack@suse.cz>

							Honza

> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/udf/super.c   |    6 +++---
>  fs/udf/udfdecl.h |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 1e4543c..998c911 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1940,7 +1940,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
>  	sb->s_op = &udf_sb_ops;
>  	sb->s_export_op = &udf_export_ops;
>  	sb->dq_op = NULL;
> -	sb->s_dirt = 0;
> +	mark_sb_clean(sb);
>  	sb->s_magic = UDF_SUPER_MAGIC;
>  	sb->s_time_gran = 1000;
>  
> @@ -2067,7 +2067,7 @@ static void udf_error(struct super_block *sb, const char *function,
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		/* mark sb error */
> -		sb->s_dirt = 1;
> +		mark_sb_dirty(sb);
>  	}
>  	va_start(args, fmt);
>  	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
> @@ -2127,7 +2127,7 @@ static int udf_sync_fs(struct super_block *sb, int wait)
>  		 * the buffer for IO
>  		 */
>  		mark_buffer_dirty(sbi->s_lvid_bh);
> -		sb->s_dirt = 0;
> +		mark_sb_clean(sb);
>  		sbi->s_lvid_dirty = 0;
>  	}
>  	mutex_unlock(&sbi->s_alloc_mutex);
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index 9079ff7..9337e3f 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -120,7 +120,7 @@ static inline void udf_updated_lvid(struct super_block *sb)
>  	WARN_ON_ONCE(((struct logicalVolIntegrityDesc *)
>  		     bh->b_data)->integrityType !=
>  		     cpu_to_le32(LVID_INTEGRITY_TYPE_OPEN));
> -	sb->s_dirt = 1;
> +	mark_sb_dirty(sb);
>  	UDF_SB(sb)->s_lvid_dirty = 1;
>  }
>  
> -- 
> 1.6.6.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
