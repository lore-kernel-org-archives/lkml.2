Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab0DSVsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:48:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848Ab0DSVsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:48:54 -0400
Date: Mon, 19 Apr 2010 14:47:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: maximilian attems <max@stro.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Ulrich Drepper <drepper@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] fcntl.h: define AT_EACCESS
Message-Id: <20100419144729.2b8180e8.akpm@linux-foundation.org>
In-Reply-To: <1271387280-19565-1-git-send-email-max@stro.at>
References: <1271387280-19565-1-git-send-email-max@stro.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010 05:08:00 +0200
maximilian attems <max@stro.at> wrote:

> noticed on a klibc build of dash that someone had left out that def:
> usr/dash/bltin/test.c:490: error: ___AT_EACCESS___ undeclared (first use in thiction)
> 
> Cc: stable@kernel.org
> Cc: Ulrich Drepper <drepper@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: maximilian attems <max@stro.at>
> ---
>  include/linux/fcntl.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> index 8603740..8bb001d 100644
> --- a/include/linux/fcntl.h
> +++ b/include/linux/fcntl.h
> @@ -39,6 +39,8 @@
>  #define AT_REMOVEDIR		0x200   /* Remove directory instead of
>                                             unlinking file.  */
>  #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
> +#define AT_EACCESS		0x200	/* Test access permitted for
> +					   effective IDs, not real IDs.  */
>  

I'm all confused.

The affects sys_faccesat(), yes?  But sys_faccesat() never gets passed
a `flags' argument so how does the behaviour which the FACCESSAT(2)
manpage describes get implemented?

This patch doesn't actually change kernel behaviour, so how can setting
AT_EACCESS change any syscall's actions?

It's a bit of a worry that the proposed value for AT_EACCESS duplicates
AT_REMOVEDIR.  I guess that, despite apeparances, they're different
namespaces.  Any thoughts on the implications of this?

