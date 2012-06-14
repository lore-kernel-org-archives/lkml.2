Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2FNWu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:50:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:33715 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2FNWu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:50:57 -0400
Date: Fri, 15 Jun 2012 00:50:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
In-Reply-To: <alpine.LFD.2.02.1206142345100.3086@ionos>
Message-ID: <alpine.LFD.2.02.1206150047510.3086@ionos>
References: <alpine.LFD.2.02.1206142345100.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

On Fri, 15 Jun 2012, Thomas Gleixner wrote:
>  void tracing_off(void)
>  {
>  	if (global_trace.buffer)
> -		ring_buffer_record_on(global_trace.buffer);
> +		ring_buffer_record_off(global_trace.buffer);

this is the gazillionst time that I wasted valuable time relying on
the not so extraordinary expectation that the kernel tracer stays
functional at least in the most basic ways.

I'm really tired of wasting hours and days just because you are unable
to keep your stuff straight and functional.

I avoided to make public fuzz about that so far, but my patience is
exhausted now.

You know yourself how many times I ranted to you on IRC or in private
conversations, but you just keep on to bask in your egocentric
mastering the uber complexity treat.

Your self description (https://lwn.net/Articles/500388/):

 Complexity is my Sun, and I am the planet that orbits around it.

is pretty accurate.

You can orbit around whatever you want and as long as you want, just
please do that on your own playground and not on the expense of
others.

I always held up to ftrace, but the repeating experience of
disfunctionality caused by your refusal to put your priorites straight
is just too annoying.

It's not the first time, that tracing_off() or other stuff I'm
depending on has been broken and caused me exhaustive loss of time.

I know that I'm not the average user of tracing, but that's not an
excuse for pushing out crap over and over again.

I'm tired of it and to be honest, I'm going to spend some quality time
on evaluating LLTNG. If it can do what I need then I switch over and
see whether it can hold up to the basic expectations of a primary
user. AFAICT from previous experience it can do that, and if Matthieu
is willing and able to cooperate on integrating with perf, then I
happily kick you off into your self chosen complexity orbit forever.

Sadly,

	Thomas

