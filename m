Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0JRSlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:41:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651Ab0JRSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:41:46 -0400
Date: Mon, 18 Oct 2010 11:40:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        toralf.foerster@gmx.de
Subject: Re: [PATCH 1/1] hostfs: fix UML crash
Message-Id: <20101018114039.503233da.akpm@linux-foundation.org>
In-Reply-To: <1287419814-20086-1-git-send-email-richard@nod.at>
References: <1287419814-20086-1-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 18:36:54 +0200 Richard Weinberger <richard@nod.at> wrote:

> 365b1818 resized f_spare within struct statfs.
> hostfs accesses f_spare directly and needs an update.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Reported-by: Toralf F__rster <toralf.foerster@gmx.de>
> Tested-by: Toralf F__rster <toralf.foerster@gmx.de>
> ---
>  fs/hostfs/hostfs_user.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
> index 6777aa0..ce2f168 100644
> --- a/fs/hostfs/hostfs_user.c
> +++ b/fs/hostfs/hostfs_user.c
> @@ -388,6 +388,6 @@ int do_statfs(char *root, long *bsize_out, long long *blocks_out,
>  	spare_out[1] = buf.f_spare[1];
>  	spare_out[2] = buf.f_spare[2];
>  	spare_out[3] = buf.f_spare[3];
> -	spare_out[4] = buf.f_spare[4];
> +
>  	return 0;
>  }

Thanks.

Is there any reason for hostfs to be playing with the f_spare field at all?
