Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0F3Jsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:48:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab0F3Jsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:48:32 -0400
Date: Wed, 30 Jun 2010 11:48:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kernel.h Fix #warning message web address.
In-Reply-To: <1277840244-3436-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz>
References: <1277840244-3436-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010, Justin P. Mattock wrote:

> Playing around with a printk program I noticed that the #warning
> message is incomplete(when using kernel headers for userspace):
> 
>  gcc printk.c -o printk
> In file included from printk.c:3:
> include/linux/kernel.h:733:2: warning: #warning Attempt to use kernel headers from user space, see http:
> 
> My guess for the web address not being displayed is "//" is treated as a comment.
> So after changing "http://" to "www." I get the web address.(using firefox with this
> address takes me right to the location). The warning looks like this:
> 
> In file included from printk.c:3:
> warning: #warning Attempt to use kernel headers from user space, see www.kernelnewbies.org/KernelHeaders 
>  
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  include/linux/kernel.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 8317ec4..768196a 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -730,7 +730,7 @@ extern int do_sysinfo(struct sysinfo *info);
>  
>  #ifndef __EXPORTED_HEADERS__
>  #ifndef __KERNEL__
> -#warning Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders
> +#warning Attempt to use kernel headers from user space, see www.kernelnewbies.org/KernelHeaders
>  #endif /* __KERNEL__ */
>  #endif /* __EXPORTED_HEADERS__ */

Hehe, ugly. How about making it a single string? GCC preprocessor 
documentation suggests the same anyway ...

	Neither `#error' nor `#warning' macro-expands its argument.
	Internal whitespace sequences are each replaced with a single space.
	The line must consist of complete tokens.  It is wisest to make the
	argument of these directives be a single string constant; this avoids
	problems with apostrophes and the like.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
