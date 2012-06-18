Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2FRXEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:04:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2FRXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:04:09 -0400
Date: Mon, 18 Jun 2012 16:04:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Jayaraman <sjayaraman@suse.com>
Cc: David Howells <dhowells@redhat.com>, Justin Lecher <jlec@gentoo.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-cachefs@redhat.com
Subject: Re: [PATCH] [RESEND] fs: cachefiles: Add support for large files in
 filesystem caching
Message-Id: <20120618160408.8d0dd792.akpm@linux-foundation.org>
In-Reply-To: <4FD5844D.4010900@suse.com>
References: <4FD5844D.4010900@suse.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 11:08:21 +0530
Suresh Jayaraman <sjayaraman@suse.com> wrote:

> The below patch which was first posted here:
> 
>    https://lkml.org/lkml/2012/4/3/193
> 
> and tested by me and picked up by the maintainer here:
> 
>    https://lkml.org/lkml/2012/5/1/57
> 
> But it seems to not to have made to the linux-next or Linus tree.
> I'm resending what it seems like a lost patch.
> 
> 
> From: Justin Lecher <jlec@gentoo.org>
> 
> Support the caching of large files.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=31182
> 
> Signed-off-by: Justin Lecher <jlec@gentoo.org>
> Tested-by: Suresh Jayaraman <sjayaraman@suse.com>
> ---
>  fs/cachefiles/rdwr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
> index 0e3c092..d136686 100644
> --- a/fs/cachefiles/rdwr.c
> +++ b/fs/cachefiles/rdwr.c
> @@ -919,7 +919,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
>  	dget(object->backer);
>  	mntget(cache->mnt);
>  	file = dentry_open(object->backer, cache->mnt, O_RDWR,
> -			   cache->cache_cred);
> +			   (O_RDWR | O_LARGEFILE), cache->cache_cred);

Doesn't compile.

How extensively was this change tested?  Please describe the testing
which was performed?

