Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2JJWRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:17:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab2JJWRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:17:01 -0400
Date: Wed, 10 Oct 2012 15:16:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
        Oleg Nesterov <oleg@redhat.com>, Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Include asm/siginfo.h in linux/coredump.h
Message-Id: <20121010151659.029b2a46.akpm@linux-foundation.org>
In-Reply-To: <1349906647-26042-1-git-send-email-richard@nod.at>
References: <1349906647-26042-1-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012 00:04:07 +0200
Richard Weinberger <richard@nod.at> wrote:

> commit 5ab1c30 (coredump: pass siginfo_t* to do_coredump() and below, not merely signr)
> added siginfo_t to linux/coredump.h but forgot to include asm/siginfo.h.
> This breaks the build for UML/i386.
> (And any other arch where asm/siginfo.h is not magically preincluded...)
> 
> In file included from arch/x86/um/elfcore.c:2:0:
> include/linux/coredump.h:15:25: error: unknown type name 'siginfo_t'
> make[1]: *** [arch/x86/um/elfcore.o] Error 1
> 
> Cc: Denys Vlasenko <vda.linux@googlemail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Amerigo Wang <amwang@redhat.com>
> Cc: "Jonathan M. Foote" <jmfoote@cert.org>
> Cc: Roland McGrath <roland@hack.frob.com>
> Cc: Pedro Alves <palves@redhat.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  include/linux/coredump.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index 1775eb8..1d73993 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -4,6 +4,7 @@
>  #include <linux/types.h>
>  #include <linux/mm.h>
>  #include <linux/fs.h>
> +#include <asm/siginfo.h>
>  
>  /*
>   * These are the only things you should do on a core-file: use only these

hm, yes.  It would be nice to jsut forward-declare the struct but we
can't do that because it's a pesky typedef.

I wonder if it would be cleaner to just include linux/signal.h?  Diving
down into the arch layer is a bit unusual.  Doesn't matter, I guess.
