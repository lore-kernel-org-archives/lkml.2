Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1FMKM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:12:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46713 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1FMKM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:12:57 -0400
Date: Mon, 13 Jun 2011 12:12:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/15] tracing: Add a free on close control mechanism for
 buffer_size_kb
Message-ID: <20110613101248.GC30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
 <20110609172910.950101158@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609172910.950101158@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> +	switch (cmd) {
> +	case TRACE_RINGBUF_FREE_ON_CLOSE: {
> +		info->free_buffer_on_close = !!arg;
> +		ret = 0;
> +		break;
> +	}
>  	}

that doesn't look very tidy.

> @@ -3635,9 +3700,12 @@ static const struct file_operations tracing_pipe_fops = {
>  };
>  
>  static const struct file_operations tracing_entries_fops = {
> -	.open		= tracing_open_generic,
> +	.open		= tracing_entries_open,
>  	.read		= tracing_entries_read,
>  	.write		= tracing_entries_write,
> +	.unlocked_ioctl	= tracing_entries_ioctl,
> +	.compat_ioctl	= tracing_entries_ioctl,

i don't like it at all that you are adding to the ftrace ABI here. 
The *only* premise of the whole /debug/tracing/ muck was to allow it 
to be human-parseable and scripted - an ioctl is clearly outside that 
scope. Instead of increasing the mess in /debug/tracing/ we want 
clean tracing done via the perf ABI ...

Thanks,

	Ingo
