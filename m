Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2CATbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:31:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52568 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2CATbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:31:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.213.32.205 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
From: Miklos Szeredi <miklos@szeredi.hu>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, dchinner@redhat.com,
        fuse-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/9] fuse: Push file_update_time() into fuse_page_mkwrite()
References: <1330602103-8851-1-git-send-email-jack@suse.cz>
	<1330602103-8851-7-git-send-email-jack@suse.cz>
Date: Thu, 01 Mar 2012 20:31:17 +0100
In-Reply-To: <1330602103-8851-7-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Thu, 1 Mar 2012 12:41:40 +0100")
Message-ID: <87obsgce4a.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: fuse-devel@lists.sourceforge.net
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/fuse/file.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 4a199fd..eade72e 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1323,6 +1323,7 @@ static int fuse_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	 */
>  	struct inode *inode = vma->vm_file->f_mapping->host;
>  
> +	file_update_time(vma->vm_file);

Fuse sets S_CMTIME in inode flags, so this is a no-op.  IOW the patch is
not needed.

Thanks,
Miklos
