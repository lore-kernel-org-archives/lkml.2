Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1AGOOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab1AGOOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:14:23 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blktrace: add missing probe argument to block_bio_complete
References: <20110107015453.GB5109@Krystal>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 07 Jan 2011 09:13:52 -0500
In-Reply-To: <20110107015453.GB5109@Krystal> (Mathieu Desnoyers's message of
	"Thu, 6 Jan 2011 20:54:53 -0500")
Message-ID: <x498vyw7qe7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:

> blktrace.c block bio complete callback needs to gain a new argument to reflect
> the newly added "error" tracepoint argument. This is needed to match the new
> block_bio_complete TRACE_EVENT as of
> commit de983a7bfcb7c020901ca6e2314cf55a4207ab5a.
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Jeff Moyer <jmoyer@redhat.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/blktrace.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux-2.6-lttng/kernel/trace/blktrace.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/trace/blktrace.c
> +++ linux-2.6-lttng/kernel/trace/blktrace.c
> @@ -785,7 +785,8 @@ static void blk_add_trace_bio_bounce(voi
>  }
>  
>  static void blk_add_trace_bio_complete(void *ignore,
> -				       struct request_queue *q, struct bio *bio)
> +				       struct request_queue *q, struct bio *bio,
> +				       int error)
>  {
>  	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE);
>  }

OK, I clearly didn't look closely enough last time.  There's no sense
passing this information down if it isn't used (as you said initially).
blk_add_trace_bio sets the error based on whether or not the
BIO_UPTODATE bit is set.  So, I think we should instead revert the patch
I sent you (Mathieu), and then completely get rid of the error field in
the TP macros.

Does that make sense to everyone else?

Cheers,
Jeff
