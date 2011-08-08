Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1HHPGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:06:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44147 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1HHPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:06:21 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Johannes Weiner <jweiner@redhat.com>
Cc: fuse-devel@lists.sourceforge.net, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] fuse: mark pages accessed when written to
References: <1311626135-14279-1-git-send-email-jweiner@redhat.com>
	<1311626135-14279-2-git-send-email-jweiner@redhat.com>
Date: Mon, 08 Aug 2011 17:06:17 +0200
In-Reply-To: <1311626135-14279-2-git-send-email-jweiner@redhat.com> (Johannes
	Weiner's message of "Mon, 25 Jul 2011 22:35:35 +0200")
Message-ID: <8762m8eydy.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <jweiner@redhat.com> writes:

> As fuse does not use the page cache library functions when userspace
> writes to a file, it did not benefit from 'c8236db mm: mark page
> accessed before we write_end()' that made sure pages are properly
> marked accessed when written to.
>
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Thanks, applied.

Miklos

> ---
>  fs/fuse/file.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 5c48126..471067e 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -14,6 +14,7 @@
>  #include <linux/sched.h>
>  #include <linux/module.h>
>  #include <linux/compat.h>
> +#include <linux/swap.h>
>  
>  static const struct file_operations fuse_direct_io_file_operations;
>  
> @@ -828,6 +829,8 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
>  		pagefault_enable();
>  		flush_dcache_page(page);
>  
> +		mark_page_accessed(page);
> +
>  		if (!tmp) {
>  			unlock_page(page);
>  			page_cache_release(page);
