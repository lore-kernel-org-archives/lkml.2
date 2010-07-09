Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0GIVFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:05:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63570 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0GIVFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:05:53 -0400
X-Authority-Analysis: v=1.1 cv=iR3a2x+wy8z+UqYHl7KFtKHYySPA0Tf/DXXAzrkvAHo= c=1 sm=0 a=km3F7jnVSo0A:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=SJS3FU_aXXKVu_WEKsMA:9 a=Dq_T2Bp6libjHTwXPAMA:7 a=cd2m5cBanf4r4SbSvEluLEMH9l4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100709205319.GA13941@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
	 <20100709203301.GA13839@merkur.ravnborg.org>
	 <1278708374.1537.161.camel@gandalf.stny.rr.com>
	 <20100709205319.GA13941@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 17:05:50 -0400
Message-ID: <1278709550.1537.164.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 22:53 +0200, Sam Ravnborg wrote:

> But in this case we have no control of the value of "." (current address)
> when we have processed (_ftrace_events) so it may even be at a 2 byte boundary.
> The linker will add padding as needed to satisfy the alignmnet of
> __syscalls_metadata - but that padding will be inbetween "." and the first
> member in __syscalls_metadata.

Fine, but this is a separate issue. I doubt the "ALIGN(8);" would have
helped us anyway. Remember what the issue we had:

ffffffff8173c438 <__start_syscalls_metadata>:
        ...

ffffffff8173c440 <__syscall_meta__mmap>:


__start_syscalls_metadata was already aligned to 8, but for some strange
reason, gcc decided to align the first member to 16.

-- Steve


