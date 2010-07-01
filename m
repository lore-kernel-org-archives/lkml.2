Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab0GAH7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:59:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0GAH7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 03:59:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH]kernel.h Move warning message about using kernel headers for userspace to types.h
Date: Thu, 1 Jul 2010 09:58:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz
References: <1277935785-6023-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1277935785-6023-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007010958.46720.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX189Xoh7FKYKdPFAAjAQkbgn3r1vcspSBnK81sK
 njZY362fVFtOv4AANVfjx/4x0mOGyy2wwb+3O8I/0N5fchXFd6
 uzj+5WbNP8HzqClmW2OCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010 00:09:45 Justin P. Mattock wrote:
> Hopefully correct, as request move the function that checks
> if userspace is using kernel headers, from kernel.h to types.h.
> (Please check.)
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Trivial change: The 'Signed-off-by'-line should start at the beginning
of the line, no space in front of it, to make all tools parse
it correctly.

Also, the text above should really be the changelog in the way
that you want it to appear in the git history. The explanatory
text about what has changed can go below the '---' line, together
with the diffstat information. Git only uses text above the line
as a changeset comment.

> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -179,6 +179,12 @@ typedef __u32 __bitwise __wsum;
>  typedef unsigned __bitwise__ gfp_t;
>  typedef unsigned __bitwise__ fmode_t;
>  
> +#ifndef __EXPORTED_HEADERS__
> +#ifndef __KERNEL__
> +#warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
> +#endif /* __KERNEL__ */
> +#endif /* __EXPORTED_HEADERS__ */
> +
>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
>  typedef u64 phys_addr_t;

Good: No more linewrap, correct use of quotation marks.
Bad: This is now inside of #ifdef __KERNEL__, so it can never be caught by
the compiler. Even if it looks like a trivial patch, it's a good idea
to test it.

I'd suggest putting the #ifndef __EXPORTED_HEADERS__ into a new #else
path of the last #ifdef __KERNEL__ of this file.

Anyway, thanks for the persistence, I know it's frustrating when a one-line
change goes through half a dozen revisions.

	Arnd
