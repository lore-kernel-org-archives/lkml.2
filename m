Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2FTWjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:39:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2FTWjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:39:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, mfasheh@suse.com, jlbec@evilplan.org,
        sunil.mushran@oracle.com
Subject: Re: [PATCH] ocfs2: Fix NULL pointer dereferrence in __ocfs2_change_file_space
In-Reply-To: <1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
	(Luis Henriques's message of "Wed, 20 Jun 2012 23:34:44 +0100")
References: <20120620145659.a5fff5f6.akpm@linux-foundation.org>
	<1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.1.50 (gnu/linux)
Date: Wed, 20 Jun 2012 23:39:51 +0100
Message-ID: <87d34tk3pk.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm... forgot to send to stable.  Is this enough?

Cc: stable@vger.kernel.org

Or do I need to re-send?

Cheers,
--
Luis

Luis Henriques <luis.henriques@canonical.com> writes:

> As ocfs2_fallocate() will invoke __ocfs2_change_file_space() with a NULL
> as the first parameter (file), it may trigger a NULL pointer dereferrence
> due to a missing check.  See http://bugs.launchpad.net/bugs/1006012.
>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  fs/ocfs2/file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6e39668..84822a4 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1950,7 +1950,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	if (ret < 0)
>  		mlog_errno(ret);
>  
> -	if (file->f_flags & O_SYNC)
> +	if (file && (file->f_flags & O_SYNC))
>  		handle->h_sync = 1;
>  
>  	ocfs2_commit_trans(osb, handle);
