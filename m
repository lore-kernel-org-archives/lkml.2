Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab2GQEZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:25:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2GQEZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:25:27 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=vNh1JVxgm5YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=YXE6w6w9E_PR3jgwLiwA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342499125.24525.11.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ftrace: using pr_fmt for better printk output
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Jovi Zhang <bookjovi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 17 Jul 2012 00:25:25 -0400
In-Reply-To: <1342496521.8377.105.camel@joe2Laptop>
References: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
	 <1342496521.8377.105.camel@joe2Laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 20:42 -0700, Joe Perches wrote:

> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> []
> > @@ -13,6 +13,8 @@
> >   *  Copyright (C) 2004 William Lee Irwin III
> >   */
> > 
> > +#define pr_fmt(fmt) "ftrace: " fmt
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Wouldn't a nicer patch be to move this into a header file and then
remove all the defines throughout the kernel tree?

Also, what is KBUILD_MODNAME defined as for non-modules? As ftrace is
not a module.

-- Steve


