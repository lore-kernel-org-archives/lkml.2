Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0F3VhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:37:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab0F3VhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:37:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH]kernel.h Fix #warning message web address.
Date: Wed, 30 Jun 2010 23:36:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
References: <1277840244-3436-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz> <4C2BB52A.7070404@gmail.com>
In-Reply-To: <4C2BB52A.7070404@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006302336.46263.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18e7avNbYzLqdlkVz/C+MPMibDN72wUzINiq0K
 0VagTbiR3bEuj3XL3w5Blo2Wto/1Wwd+B1C8JhenmbOB2GFR+v
 m0VZT8kH+8Fo8Vrq3RI1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010 23:20:42 Justin P. Mattock wrote:
> 
> > Hehe, ugly. How about making it a single string? GCC preprocessor
> > documentation suggests the same anyway ...
> >
> >       Neither `#error' nor `#warning' macro-expands its argument.
> >       Internal whitespace sequences are each replaced with a single space.
> >       The line must consist of complete tokens.  It is wisest to make the
> >       argument of these directives be a single string constant; this avoids
> >       problems with apostrophes and the like.
> >
 
What this is telling you is to put the text into a string constant, which
means you add quotation marks at the beginning and end of the line, like

#warning "see http://example.com/"

>  From 45f24db45faa06aad01cfc62ff4b475380e5cb11 Mon Sep 17 00:00:00 2001
> From: Justin P. Mattock <justinmattock@gmail.com>
> Date: Wed, 30 Jun 2010 14:06:18 -0700
> Subject: [PATCH]kernel.h Fix #warning message according to the GCC 
> preprocessor docs.

BTW, your mail client adds incorrect word wrapping.

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

Here, too.

Also, since you're already touching the warning message, it would be
nice to move it from kernel.h to types.h, which is much more commonly
used. When I introduced the message, I made the mistake to think
that kernel.h was universally used by the majority of all headers,
which turned out to be wrong. linux/types.h (or possibly linux/stddef.h)
seems to be the most commonly used one, so that would be a more
adequate place.

	Arnd
