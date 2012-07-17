Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2GQFXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:23:49 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35234 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2GQFXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:23:47 -0400
MIME-Version: 1.0
In-Reply-To: <1342499125.24525.11.camel@gandalf.stny.rr.com>
References: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
	<1342496521.8377.105.camel@joe2Laptop>
	<1342499125.24525.11.camel@gandalf.stny.rr.com>
Date: Tue, 17 Jul 2012 13:23:46 +0800
Message-ID: <CACV3sb+EoHPqM7ih-5HpiT-o9CqobhaiJJ3E7-8H7N=tR7URig@mail.gmail.com>
Subject: Re: [PATCH] ftrace: using pr_fmt for better printk output
From: Jovi Zhang <bookjovi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 12:25 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-07-16 at 20:42 -0700, Joe Perches wrote:
>
>> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> []
>> > @@ -13,6 +13,8 @@
>> >   *  Copyright (C) 2004 William Lee Irwin III
>> >   */
>> >
>> > +#define pr_fmt(fmt) "ftrace: " fmt
>>
>> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> Wouldn't a nicer patch be to move this into a header file and then
> remove all the defines throughout the kernel tree?

Maybe it's hard to achieve that.
subsystem name is unique with each other, it should be visible in source file,
if include into header file, then each .c file might need a own header
file for include pr_fmt
definition, then that header file cannot be reusable(avoid subsystem
name conflicts).

>
> Also, what is KBUILD_MODNAME defined as for non-modules? As ftrace is
> not a module.
Yes, that's why I cannot use KBUILD_MODNAME in patch.

>
> -- Steve

I don't make sure if there have some method or skill to let GCC knows
subsystem name automatically,
use built-in macro __FILE__? but this need condition of subsystem name
is same as file name,
not so easily to guarantee that.


.jovi
