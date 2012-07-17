Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2GQF1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:27:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40619 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751675Ab2GQF1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:27:05 -0400
Message-ID: <1342502824.8377.124.camel@joe2Laptop>
Subject: Re: [PATCH] ftrace: using pr_fmt for better printk output
From: Joe Perches <joe@perches.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 22:27:04 -0700
In-Reply-To: <CACV3sb+EoHPqM7ih-5HpiT-o9CqobhaiJJ3E7-8H7N=tR7URig@mail.gmail.com>
References: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
	 <1342496521.8377.105.camel@joe2Laptop>
	 <1342499125.24525.11.camel@gandalf.stny.rr.com>
	 <CACV3sb+EoHPqM7ih-5HpiT-o9CqobhaiJJ3E7-8H7N=tR7URig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 13:23 +0800, Jovi Zhang wrote:
> On Tue, Jul 17, 2012 at 12:25 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 2012-07-16 at 20:42 -0700, Joe Perches wrote:
> >
> >> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> >> []
> >> > @@ -13,6 +13,8 @@
> >> >   *  Copyright (C) 2004 William Lee Irwin III
> >> >   */
> >> >
> >> > +#define pr_fmt(fmt) "ftrace: " fmt
> >>
> >> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> > Wouldn't a nicer patch be to move this into a header file and then
> > remove all the defines throughout the kernel tree?
> 
> Maybe it's hard to achieve that.
> subsystem name is unique with each other, it should be visible in source file,
> if include into header file, then each .c file might need a own header
> file for include pr_fmt
> definition, then that header file cannot be reusable(avoid subsystem
> name conflicts).
> 
> >
> > Also, what is KBUILD_MODNAME defined as for non-modules? As ftrace is
> > not a module.
> Yes, that's why I cannot use KBUILD_MODNAME in patch.

Incorrect, try it.


