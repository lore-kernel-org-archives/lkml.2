Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2JJWVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:21:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913Ab2JJWVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:21:08 -0400
Date: Thu, 11 Oct 2012 00:20:56 +0200
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
        Oleg Nesterov <oleg@redhat.com>, Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Include asm/siginfo.h in linux/coredump.h
Message-ID: <20121011002056.09c7c2bb@spider.haslach.nod.at>
In-Reply-To: <20121010151659.029b2a46.akpm@linux-foundation.org>
References: <1349906647-26042-1-git-send-email-richard@nod.at>
	<20121010151659.029b2a46.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 10 Oct 2012 15:16:59 -0700
schrieb Andrew Morton <akpm@linux-foundation.org>:

> On Thu, 11 Oct 2012 00:04:07 +0200
> Richard Weinberger <richard@nod.at> wrote:
> 
> > commit 5ab1c30 (coredump: pass siginfo_t* to do_coredump() and
> > below, not merely signr) added siginfo_t to linux/coredump.h but
> > forgot to include asm/siginfo.h. This breaks the build for UML/i386.
> > (And any other arch where asm/siginfo.h is not magically
> > preincluded...)
> > 
> > In file included from arch/x86/um/elfcore.c:2:0:
> > include/linux/coredump.h:15:25: error: unknown type name 'siginfo_t'
> > make[1]: *** [arch/x86/um/elfcore.o] Error 1
> > 
> > Cc: Denys Vlasenko <vda.linux@googlemail.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Amerigo Wang <amwang@redhat.com>
> > Cc: "Jonathan M. Foote" <jmfoote@cert.org>
> > Cc: Roland McGrath <roland@hack.frob.com>
> > Cc: Pedro Alves <palves@redhat.com>
> > Cc: Fengguang Wu <fengguang.wu@intel.com>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  include/linux/coredump.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> > index 1775eb8..1d73993 100644
> > --- a/include/linux/coredump.h
> > +++ b/include/linux/coredump.h
> > @@ -4,6 +4,7 @@
> >  #include <linux/types.h>
> >  #include <linux/mm.h>
> >  #include <linux/fs.h>
> > +#include <asm/siginfo.h>
> >  
> >  /*
> >   * These are the only things you should do on a core-file: use
> > only these
> 
> hm, yes.  It would be nice to jsut forward-declare the struct but we
> can't do that because it's a pesky typedef.

I know. :-\

> I wonder if it would be cleaner to just include linux/signal.h?
> Diving down into the arch layer is a bit unusual.  Doesn't matter, I
> guess.

I chose asm/siginfo.h because other users of siginfo_t also just
include this file and linux/signal.h includes much more than we
actually need...

Thanks,
//richard
