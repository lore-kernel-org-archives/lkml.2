Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab1KPRF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:05:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1KPRF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:05:57 -0500
Subject: Re: [PATCH] tracing: add trace console
From: Steven Rostedt <srostedt@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1321462856.4181.28.camel@frodo>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <20111116151037.GA26166@infradead.org>
	 <1321456652.4502.12.camel@jlt3.sipsolutions.net>
	 <1321461693.4181.26.camel@frodo>
	 <1321461902.4502.14.camel@jlt3.sipsolutions.net>
	 <1321462856.4181.28.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat Inc
Date: Wed, 16 Nov 2011 12:05:45 -0500
Message-ID: <1321463145.4181.30.camel@frodo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 12:00 -0500, Steven Rostedt wrote:

> diff --git a/kernel/printk.c b/kernel/printk.c
> index 1455a0d..4b8445a 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -542,6 +542,7 @@ MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
>  static void _call_console_drivers(unsigned start,
>  				unsigned end, int msg_log_level)
>  {
> +	trace_console(&LOG_BUF(start), end - start);

And since we don't want to trace when end == start, we can use
TRACE_EVENT_CONDITION() and have cond be: len > 0. (where len is the
parameter that takes the end - start.)

This will keep the branch to test len > 0 inside the tracepoint, and it
wont affect the logic when tracing is disabled.

-- Steve


>  	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
>  			console_drivers && start != end) {
>  		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
> 



