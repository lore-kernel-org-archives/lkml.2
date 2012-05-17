Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967833Ab2EQXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:10:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965794Ab2EQXKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:10:54 -0400
Date: Thu, 17 May 2012 16:10:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vladimir =?UTF-8?Q?'=CF=86-coder/phcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH] Increase file size limit on FreeBSD UFS flavours
Message-Id: <20120517161052.d37cf8ae.akpm@linux-foundation.org>
In-Reply-To: <4FAFBC30.4040305@gmail.com>
References: <4FAFBC30.4040305@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2012 15:50:40 +0200
Vladimir '__-coder/phcoder' Serbinenko  <phcoder@gmail.com> wrote:

> Increase the file size limit on FreeBSD UFS flavours.
> 
> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
> 
> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> index ac8e279..7e80a68 100644
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c
> @@ -768,6 +768,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
>  		uspi->s_fshift = 9;
>  		uspi->s_sbsize = super_block_size = 1536;
>  		uspi->s_sbbase = 0;
> +		sb->s_maxbytes = MAX_LFS_FILESIZE;
>  		flags |= UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44BSD;
>  		break;
>  	case UFS_MOUNT_UFSTYPE_UFS2:
> @@ -778,6 +779,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
>  		uspi->s_fshift = 9;
>  		uspi->s_sbsize = super_block_size = 1536;
>  		uspi->s_sbbase =  0;
> +		sb->s_maxbytes = MAX_LFS_FILESIZE;
>  		flags |= UFS_TYPE_UFS2 | UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44BSD;
>  		break;
>  		

But MAX_NON_LFS exists for a reason.  Before this change, the Linux UFS
implementation had never had to deal with >4G files (I assume).

Are you telling us that the fs has been thoroughly audited and tested
with large files and that it all worked OK with no other changes?
