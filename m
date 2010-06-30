Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab0F3VXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:23:06 -0400
Received: from xenotime.net ([72.52.115.56]:60815 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757226Ab0F3VXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:23:04 -0400
Date: Wed, 30 Jun 2010 14:22:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kernel.h Fix #warning message web address.
Message-Id: <20100630142259.a5f4dcb5.rdunlap@xenotime.net>
In-Reply-To: <4C2BB52A.7070404@gmail.com>
References: <1277840244-3436-1-git-send-email-justinmattock@gmail.com>
	<alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz>
	<4C2BB52A.7070404@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 14:20:42 -0700 Justin P. Mattock wrote:

> 
> > Hehe, ugly. How about making it a single string? GCC preprocessor
> > documentation suggests the same anyway ...
> >
> > 	Neither `#error' nor `#warning' macro-expands its argument.
> > 	Internal whitespace sequences are each replaced with a single space.
> > 	The line must consist of complete tokens.  It is wisest to make the
> > 	argument of these directives be a single string constant; this avoids
> > 	problems with apostrophes and the like.

Doesn't that mean just put double quotation marks around the entire message string??



> o.k. jiri, here is what I came up with, after re-reading and looking at 
> other in the kernel(below).
> 
> 
> 
>  From 45f24db45faa06aad01cfc62ff4b475380e5cb11 Mon Sep 17 00:00:00 2001
> From: Justin P. Mattock <justinmattock@gmail.com>
> Date: Wed, 30 Jun 2010 14:06:18 -0700
> Subject: [PATCH]kernel.h Fix #warning message according to the GCC 
> preprocessor docs.
> 
> received this #warning from a simple printk program and noticed the web
> address is not showing up:
>   gcc printk.c -o printk
> In file included from printk.c:3:
> include/linux/kernel.h:733:2: warning: #warning Attempt to use kernel 
> headers from user space, see http:
> 
> after the changes the warning should just say:
> #warning Attempt to use kernel headers from user space!
> 
>   Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> ---
>   include/linux/kernel.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 8317ec4..b542961 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -730,7 +730,7 @@ extern int do_sysinfo(struct sysinfo *info);
> 
>   #ifndef __EXPORTED_HEADERS__
>   #ifndef __KERNEL__
> -#warning Attempt to use kernel headers from user space, see 
> http://kernelnewbies.org/KernelHeaders
> +#warning Attempt to use kernel headers from user space!
>   #endif /* __KERNEL__ */
>   #endif /* __EXPORTED_HEADERS__ */
> 
> -- 
> 1.7.1.rc1.21.gf3bd6
> 
> 
> now I'm wondering if there should be a lead to the documentation with 
> this web address(seems grep is not finding anything that I might be able 
> to use).or just leave as is, and let people connect-the-dots!!
> 
> let me know..
> 
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
