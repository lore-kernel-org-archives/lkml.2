Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0GIUqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:46:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0GIUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:46:17 -0400
X-Authority-Analysis: v=1.1 cv=iR3a2x+wy8z+UqYHl7KFtKHYySPA0Tf/DXXAzrkvAHo= c=1 sm=0 a=km3F7jnVSo0A:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=90gqgTWgj4aegioYpGoA:9 a=FOaxgPxymWw5anFu1co7ZwKeM88A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL][for 2.6.35] tracing: Add alignment to
 syscall metadata declarations
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Maciej@antispam.struernethosting.dk
In-Reply-To: <20100709203301.GA13839@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
	 <20100709203301.GA13839@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 16:46:14 -0400
Message-ID: <1278708374.1537.161.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 22:33 +0200, Sam Ravnborg wrote:
> On Fri, Jul 09, 2010 at 03:56:42PM -0400, Steven Rostedt wrote:

> This looks like a fix that just hide the real bug.
> If I remember the original report correct the problem is
> that the symbol:
> 
>     __start_syscalls_metadata
> 
> Does not point to a valid syscall entry.
> 
> The symbol is assigned in vmlinux.lds.h like this:
> #define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
>                          *(__syscalls_metadata)                         \
>                          VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
> 
> Now consider what is happening if we have the following scanario:
> 
> . equals 0x1004 so __start_syscalls_metadata is set to 0x1004
> But __syscall_metadata require 8 byte alignment so it starts at 0x1008.


I did not know that the linker could start a section at a half a word
size. That seems to me to be a linker bug.

If a word for a box is 8 bytes than the linker had better start sections
on 8 byte boundaries. Otherwise I would think other things may break.

For 4 byte word boxes, this should be safe anyway.

-- Steve



