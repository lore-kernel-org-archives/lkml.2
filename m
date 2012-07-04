Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab2GDHe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:34:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54256 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2GDHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:34:22 -0400
Date: Wed, 4 Jul 2012 00:34:15 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        joe.jin@oracle.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Ocfs2-devel] [PATCH v4 2/2] ocfs2: clear unaligned io flag
 when dio fails
Message-ID: <20120704073415.GF9863@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Junxiao Bi <junxiao.bi@oracle.com>,
	ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
	joe.jin@oracle.com, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, akpm@linux-foundation.org
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
 <1340788195-20623-3-git-send-email-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340788195-20623-3-git-send-email-junxiao.bi@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 05:09:55PM +0800, Junxiao Bi wrote:
> The unaligned io flag is set in the kiocb when an unaligned
> dio is issued, it should be cleared even when the dio fails,
> or it may affect the following io which are using the same
> kiocb.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: stable@vger.kernel.org

This patch is now part of the 'fixes' branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/file.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 061591a..98513c8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2422,8 +2422,10 @@ out_dio:
>  		unaligned_dio = 0;
>  	}
>  
> -	if (unaligned_dio)
> +	if (unaligned_dio) {
> +		ocfs2_iocb_clear_unaligned_aio(iocb);
>  		atomic_dec(&OCFS2_I(inode)->ip_unaligned_aio);
> +	}
>  
>  out:
>  	if (rw_level != -1)
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Up and down that road in our worn out shoes,
 Talking bout good things and singing the blues."

			http://www.jlbec.org/
			jlbec@evilplan.org
