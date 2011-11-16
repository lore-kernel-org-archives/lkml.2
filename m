Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1KPSdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:33:08 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:42504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1KPSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:33:07 -0500
Subject: Re: [PATCH] tracing: add trace console
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
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
Date: Wed, 16 Nov 2011 19:33:00 +0100
Message-ID: <1321468380.4502.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 12:00 -0500, Steven Rostedt wrote:
> On Wed, 2011-11-16 at 17:45 +0100, Johannes Berg wrote:
> 
> > I briefly looked at it just after writing the email, but quickly got
> > lost in printk.c because of the multi-line handling it has. We could
> > instead trace each call to printk(), so the multi-line stuff would end
> > up in multiple events, but all of that code is too much vodoo for me :)
> 
> Here's what can go into printk.c:
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 1455a0d..4b8445a 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -542,6 +542,7 @@ MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
>  static void _call_console_drivers(unsigned start,
>  				unsigned end, int msg_log_level)
>  {
> +	trace_console(&LOG_BUF(start), end - start);
>  	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
>  			console_drivers && start != end) {
>  		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
> 
> 
> And then you can make a TRACE_EVENT(console) that takes a buffer and a
> len, and write that to the ring buffer.

Yes, of course, but if we're going to modify the code then I thought we
should probably trace everything independent of the console printk
level.

johannes

