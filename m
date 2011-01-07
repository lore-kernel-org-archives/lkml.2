Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1AGRlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:41:14 -0500
Received: from mail.openrapids.net ([64.15.138.104]:59068 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754396Ab1AGRlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:41:13 -0500
Date: Fri, 7 Jan 2011 12:41:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blktrace: add missing probe argument to
	block_bio_complete
Message-ID: <20110107174110.GA23082@Krystal>
References: <20110107015453.GB5109@Krystal> <x498vyw7qe7.fsf@segfault.boston.devel.redhat.com> <4D272EBA.5000703@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D272EBA.5000703@kernel.dk>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:21:15 up 44 days, 22:24,  6 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (axboe@kernel.dk) wrote:
> On 2011-01-07 15:13, Jeff Moyer wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> > 
> >> blktrace.c block bio complete callback needs to gain a new argument to reflect
> >> the newly added "error" tracepoint argument. This is needed to match the new
> >> block_bio_complete TRACE_EVENT as of
> >> commit de983a7bfcb7c020901ca6e2314cf55a4207ab5a.
> >>
> >> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >> CC: Jeff Moyer <jmoyer@redhat.com>
> >> CC: Steven Rostedt <rostedt@goodmis.org>
> >> CC: Frederic Weisbecker <fweisbec@gmail.com>
> >> CC: Ingo Molnar <mingo@elte.hu>
> >> CC: Thomas Gleixner <tglx@linutronix.de>
> >> CC: Jens Axboe <axboe@kernel.dk>
> >> CC: Li Zefan <lizf@cn.fujitsu.com>
> >> ---
> >>  kernel/trace/blktrace.c |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> Index: linux-2.6-lttng/kernel/trace/blktrace.c
> >> ===================================================================
> >> --- linux-2.6-lttng.orig/kernel/trace/blktrace.c
> >> +++ linux-2.6-lttng/kernel/trace/blktrace.c
> >> @@ -785,7 +785,8 @@ static void blk_add_trace_bio_bounce(voi
> >>  }
> >>  
> >>  static void blk_add_trace_bio_complete(void *ignore,
> >> -				       struct request_queue *q, struct bio *bio)
> >> +				       struct request_queue *q, struct bio *bio,
> >> +				       int error)
> >>  {
> >>  	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE);
> >>  }
> > 
> > OK, I clearly didn't look closely enough last time.  There's no sense
> > passing this information down if it isn't used (as you said initially).
> > blk_add_trace_bio sets the error based on whether or not the
> > BIO_UPTODATE bit is set.  So, I think we should instead revert the patch
> > I sent you (Mathieu), and then completely get rid of the error field in
> > the TP macros.
> > 
> > Does that make sense to everyone else?
> 
> We usually use BIO_UPTODATE if we have no other information available.
> So if we have, then we should use it.

Good point. I tested your patch below applied after "trace event block fix
unassigned field", and it builds fine. Please feel free to add my

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Are you planning to apply it on top of "blktrace: add missing probe argument to
block_bio_complete" ? (which I see you have merged in block for-next)

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
