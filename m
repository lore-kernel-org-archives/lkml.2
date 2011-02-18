Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1BRMue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 07:50:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab1BRMuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 07:50:32 -0500
Date: Fri, 18 Feb 2011 13:50:12 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] Revert "tracing: Add unstable sched clock note
 to the warning"
Message-ID: <20110218125012.GA2604@jolsa.brq.redhat.com>
References: <tip-e9345aab675382176740bc8a2c6d3caf1510e46d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-e9345aab675382176740bc8a2c6d3caf1510e46d@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops, overlooked this one... will send new patch shortly, sorry

jirka

On Fri, Feb 18, 2011 at 10:39:12AM +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  e9345aab675382176740bc8a2c6d3caf1510e46d
> Gitweb:     http://git.kernel.org/tip/e9345aab675382176740bc8a2c6d3caf1510e46d
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 18 Feb 2011 08:09:49 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 18 Feb 2011 08:09:49 +0100
> 
> Revert "tracing: Add unstable sched clock note to the warning"
> 
> This reverts commit 5e38ca8f3ea423442eaafe1b7e206084aa38120a.
> 
> Breaks the build of several !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
> architectures.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Message-ID: <20110217171823.GB17058@elte.hu>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/ring_buffer.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7739893..bd1c35a 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2163,14 +2163,10 @@ rb_reserve_next_event(struct ring_buffer *buffer,
>  		delta = diff;
>  		if (unlikely(test_time_stamp(delta))) {
>  			WARN_ONCE(delta > (1ULL << 59),
> -				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n%s",
> +				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
>  				  (unsigned long long)delta,
>  				  (unsigned long long)ts,
> -				  (unsigned long long)cpu_buffer->write_stamp,
> -				  sched_clock_stable ? "" :
> -				  "If you just came from a suspend/resume,\n"
> -				  "please switch to the trace global clock:\n"
> -				  "  echo global > /sys/kernel/debug/tracing/trace_clock\n");
> +				  (unsigned long long)cpu_buffer->write_stamp);
>  			add_timestamp = 1;
>  		}
>  	}
