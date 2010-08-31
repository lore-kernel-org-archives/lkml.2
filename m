Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0HaOik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:38:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47715 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab0HaOij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IlIxf7oeiEeEvcy9aAmtchb+3x+DQ4yS7vLVYo5y80aYMn8wzTky2OURqBREGwjgbp
         g3vgVNnRfRsGy5ed0aZq5YViDxmr/SvEEeNwxHB0Ez9+rMEaahqiWKarA5uGx+x8BXs/
         7aOtsLUOr2FtOmtOtxWUUk/2FhE7abDsY6AJ8=
Date: Tue, 31 Aug 2010 16:21:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Blanchard <anton@samba.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/trace_stack: Fix stack trace on ppc64
Message-ID: <20100831142111.GA5259@nowhere>
References: <20100825013238.GE28360@kryten> <1283218310.1377.50.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283218310.1377.50.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 09:31:50PM -0400, Steven Rostedt wrote:
> On Wed, 2010-08-25 at 11:32 +1000, Anton Blanchard wrote:
> > save_stack_trace() stores the instruction pointer, not the function
> > descriptor. On ppc64 the trace stack code currently dereferences the
> > instruction pointer and shows 8 bytes of instructions in our backtraces:
> > 
> > # cat /sys/kernel/debug/tracing/stack_trace
> >         Depth    Size   Location    (26 entries)
> >         -----    ----   --------
> >   0)     5424     112   0x6000000048000004
> >   1)     5312     160   0x60000000ebad01b0
> >   2)     5152     160   0x2c23000041c20030
> >   3)     4992     240   0x600000007c781b79
> >   4)     4752     160   0xe84100284800000c
> >   5)     4592     192   0x600000002fa30000
> >   6)     4400     256   0x7f1800347b7407e0
> >   7)     4144     208   0xe89f0108f87f0070
> >   8)     3936     272   0xe84100282fa30000
> > 
> > Since we aren't dealing with function descriptors, use %pS instead of %pF
> > to fix it:
> > 
> > # cat /sys/kernel/debug/tracing/stack_trace
> >         Depth    Size   Location    (26 entries)
> >         -----    ----   --------
> >   0)     5424     112   ftrace_call+0x4/0x8
> >   1)     5312     160   .current_io_context+0x28/0x74
> >   2)     5152     160   .get_io_context+0x48/0xa0
> >   3)     4992     240   .cfq_set_request+0x94/0x4c4
> >   4)     4752     160   .elv_set_request+0x60/0x84
> >   5)     4592     192   .get_request+0x2d4/0x468
> >   6)     4400     256   .get_request_wait+0x7c/0x258
> >   7)     4144     208   .__make_request+0x49c/0x610
> >   8)     3936     272   .generic_make_request+0x390/0x434
> > 
> > Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> Thanks, I'll test this to make sure it doesn't break x86, and then push
> it into a stable/-rc patch queue.
> 
> -- Steve


Ingo has applied it already in perf/urgent.

Thanks.

