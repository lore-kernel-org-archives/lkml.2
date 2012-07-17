Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2GQFc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:32:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33313 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2GQFcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <1342501653.8377.123.camel@joe2Laptop>
References: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
	<1342496521.8377.105.camel@joe2Laptop>
	<1342499125.24525.11.camel@gandalf.stny.rr.com>
	<1342501653.8377.123.camel@joe2Laptop>
Date: Tue, 17 Jul 2012 13:32:22 +0800
Message-ID: <CACV3sb+H_tLDw=d1pjR5znVZSst+DqJ08p4eBTRcsKhzqsgnwg@mail.gmail.com>
Subject: Re: [PATCH] ftrace: using pr_fmt for better printk output
From: Jovi Zhang <bookjovi@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 1:07 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-07-17 at 00:25 -0400, Steven Rostedt wrote:
>> On Mon, 2012-07-16 at 20:42 -0700, Joe Perches wrote:
>>
>> > > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> > []
>> > > @@ -13,6 +13,8 @@
>> > >   *  Copyright (C) 2004 William Lee Irwin III
>> > >   */
>> > >
>> > > +#define pr_fmt(fmt) "ftrace: " fmt
>> >
>> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>
>> Wouldn't a nicer patch be to move this into a header file and then
>> remove all the defines throughout the kernel tree?
>
> Maybe.  There are modules that use common header files
> like you suggest.  It does mean that header must be the
> #included before any other #include that might
> #include <linux/kernel.h> or printk.h.
>
> Right now, if pr_fmt isn't #defined, printk.h
> has a default definition of:
>
> #ifndef pr_fmt
> #define pr_fmt(fmt) fmt
> #endif
>
> My goal is to change that to:
>
> #ifndef pr_fmt
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> #endif
>
> in 3.8 (maybe 3.7) and remove all of these then
> useless, duplicate #defines shortly afterward.
>
> https://lkml.org/lkml/2012/3/27/247
>
>> Also, what is KBUILD_MODNAME defined as for non-modules? As ftrace is
>> not a module.
>
> It depends on the Makefile.
>
> scripts/Makefile.lib:# $(modname_flags) #defines KBUILD_MODNAME as the name of the module it will
> scripts/Makefile.lib-# end up in (or would, if it gets compiled in)
> scripts/Makefile.lib-# Note: Files that end up in two or more modules are compiled without the
> scripts/Makefile.lib:#       KBUILD_MODNAME definition. The reason is that any made-up name would
> scripts/Makefile.lib-#       differ in different configs.
> scripts/Makefile.lib-name-fix = $(subst $(comma),_,$(subst -,_,$1))
> scripts/Makefile.lib-basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
> scripts/Makefile.lib-modname_flags  = $(if $(filter 1,$(words $(modname))),\
> scripts/Makefile.lib:                 -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")
>
Hmm, that would make sense, get subsystem name from Makefile.

Joe, there will delete all this pr_fmt definition in .c file in 3.8(or
3.7) as you metioned, so we can ingnore this patch.

.Jovi
