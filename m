Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2GQFhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:37:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39312 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750847Ab2GQFhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:37:36 -0400
Message-ID: <1342503455.8377.127.camel@joe2Laptop>
Subject: Re: [PATCH] ftrace: using pr_fmt for better printk output
From: Joe Perches <joe@perches.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 22:37:35 -0700
In-Reply-To: <CACV3sb+H_tLDw=d1pjR5znVZSst+DqJ08p4eBTRcsKhzqsgnwg@mail.gmail.com>
References: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
	 <1342496521.8377.105.camel@joe2Laptop>
	 <1342499125.24525.11.camel@gandalf.stny.rr.com>
	 <1342501653.8377.123.camel@joe2Laptop>
	 <CACV3sb+H_tLDw=d1pjR5znVZSst+DqJ08p4eBTRcsKhzqsgnwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 13:32 +0800, Jovi Zhang wrote:
> On Tue, Jul 17, 2012 at 1:07 PM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2012-07-17 at 00:25 -0400, Steven Rostedt wrote:
[]
> >> Also, what is KBUILD_MODNAME defined as for non-modules? As ftrace is
> >> not a module.
> >
> > It depends on the Makefile.
> >
> > scripts/Makefile.lib:# $(modname_flags) #defines KBUILD_MODNAME as the name of the module it will
> > scripts/Makefile.lib-# end up in (or would, if it gets compiled in)
> > scripts/Makefile.lib-# Note: Files that end up in two or more modules are compiled without the
> > scripts/Makefile.lib:#       KBUILD_MODNAME definition. The reason is that any made-up name would
> > scripts/Makefile.lib-#       differ in different configs.
> > scripts/Makefile.lib-name-fix = $(subst $(comma),_,$(subst -,_,$1))
> > scripts/Makefile.lib-basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
> > scripts/Makefile.lib-modname_flags  = $(if $(filter 1,$(words $(modname))),\
> > scripts/Makefile.lib:                 -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")
> >
> Hmm, that would make sense, get subsystem name from Makefile.
> 
> Joe, there will delete all this pr_fmt definition in .c file in 3.8(or
> 3.7) as you metioned, so we can ingnore this patch.

Not quite.  The uses that have embedded prefixes need updating.
You've done that in bits of this patch.

