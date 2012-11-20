Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2KTQVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:21:51 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54362 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2KTQVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:21:49 -0500
Message-ID: <50ABAE1A.2020203@inktank.com>
Date: Tue, 20 Nov 2012 10:21:46 -0600
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Cyril Roelandt <tipecaml@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sage@inktank.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] ceph: fix dentry reference leak in ceph_encode_fh().
References: <1352666971-13551-1-git-send-email-tipecaml@gmail.com> <1352666971-13551-4-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1352666971-13551-4-git-send-email-tipecaml@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 02:49 PM, Cyril Roelandt wrote:
> dput() was not called in the error path.
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

This looks good, thanks a lot.  I'll apply it.

Reviewed-by: Alex Elder <elder@inktank.com>

> ---
>  fs/ceph/export.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 9349bb3..ca3ab3f 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -56,13 +56,15 @@ static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
>  	struct ceph_nfs_confh *cfh = (void *)rawfh;
>  	int connected_handle_length = sizeof(*cfh)/4;
>  	int handle_length = sizeof(*fh)/4;
> -	struct dentry *dentry = d_find_alias(inode);
> +	struct dentry *dentry;
>  	struct dentry *parent;
>  
>  	/* don't re-export snaps */
>  	if (ceph_snap(inode) != CEPH_NOSNAP)
>  		return -EINVAL;
>  
> +	dentry = d_find_alias(inode);
> +
>  	/* if we found an alias, generate a connectable fh */
>  	if (*max_len >= connected_handle_length && dentry) {
>  		dout("encode_fh %p connectable\n", dentry);
> 

