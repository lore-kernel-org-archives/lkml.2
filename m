Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0GJAWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:22:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55003 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab0GJAWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:22:23 -0400
X-Authority-Analysis: v=1.1 cv=iR3a2x+wy8z+UqYHl7KFtKHYySPA0Tf/DXXAzrkvAHo= c=1 sm=0 a=km3F7jnVSo0A:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=7gkXJVJtAAAA:8 a=UTW6bu58LHd8JGrgy54A:9 a=IqIn_TG7WgO25IV8R8d6AYy5CfEA:4 a=PUjeQqilurYA:10 a=JmBWkid0h3cA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL][for 2.6.35] tracing: Add alignment to
 syscall metadata declarations
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Maciej@antispam.struernethosting.dk
In-Reply-To: <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
	 <20100709203301.GA13839@merkur.ravnborg.org>
	 <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 20:22:19 -0400
Message-ID: <1278721339.1537.166.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 14:25 -0700, Linus Torvalds wrote:
> On Fri, Jul 9, 2010 at 1:33 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > Something like this:
> > (whitespace damaged)
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index 48c5299..64430d3 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -133,7 +133,8 @@
> >  #endif
> >
> >  #ifdef CONFIG_FTRACE_SYSCALLS
> > -#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .;        \
> > +#define TRACE_SYSCALLS() . = ALIGN(8);                                 \
> > +                        VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
> >                         *(__syscalls_metadata)                         \
> >                         VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
> >  #else
> 
> If this is confirmed to fix it, then I would much prefer this version.

Zeev,

Can you try Sam's version and remove mine. I'd like to see if that fixes
the issue too.

Thanks,

-- Steve


