Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab1DMKJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:09:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab1DMKJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:09:08 -0400
Subject: Re: [PATCH 1/2] gfs:remove a warning in gfs2_lookup_by_inum()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Weiping =?UTF-8?Q?Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1302489770-31552-1-git-send-email-panweiping3@gmail.com>
References: <1302489770-31552-1-git-send-email-panweiping3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 13 Apr 2011 11:11:55 +0100
Message-ID: <1302689515.2613.5.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch, however a fix for this is already in the GFS2 -nmw
git tree,

Steve.

On Mon, 2011-04-11 at 10:42 +0800, Weiping Pan(潘卫平) wrote:
> /home/pwp/mysvn/linux/linux-2.6/fs/gfs2/inode.c: In function
> ‘gfs2_lookup_by_inum’: /home/pwp/mysvn/linux/linux-2.6/fs/gfs2/inode.c:188:16:
> warning: ‘inode’ may be used uninitialized in this function
> 
> Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
> ---
>  fs/gfs2/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index 97d54a2..5b937c6 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -185,7 +185,7 @@ struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
>  {
>  	struct super_block *sb = sdp->sd_vfs;
>  	struct gfs2_holder i_gh;
> -	struct inode *inode;
> +	struct inode *inode = NULL;
>  	int error;
>  
>  	error = gfs2_glock_nq_num(sdp, no_addr, &gfs2_inode_glops,


