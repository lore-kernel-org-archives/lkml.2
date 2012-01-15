Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2AOSan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:30:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2AOSam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:30:42 -0500
Date: Sun, 15 Jan 2012 19:24:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120115182441.GA24694@redhat.com>
References: <20120110174509.GA30802@redhat.com> <20120113182015.GA3902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113182015.GA3902@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Oleg Nesterov wrote:
>
> Hello,

ping ;)

> Please pull from
>
> 	git://github.com/utrace/linux sigtrace
>
>
> Another (4th) attempt to push these simple changes, now in the form
> of a pull request (yes, github, I still can't restore my korg account).
>
> 2/2 looks like a bugfix to me, but 1/2 changes the output from
> trace_signal_generate() and removes trace_signal_overflow_fail.
> In essence the change is:
>
> 	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
> 	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",
>
> where
> 	- grp=0/1 means private or shared
>
> 	- res is enum {
> 			TRACE_SIGNAL_DELIVERED,
> 			TRACE_SIGNAL_IGNORED,
> 			TRACE_SIGNAL_ALREADY_PENDING,
> 			TRACE_SIGNAL_OVERFLOW_FAIL,
> 			TRACE_SIGNAL_LOSE_INFO,
> 		};
>
> Obviously this is the user visible change. But personally I do
> agree with Seiji who requested this feature. Currently
> trace_signal_generate() just records the fact that __send_signal()
> was called, you can't know whether the signal was actually sent
> or not.
>
> Steven Rostedt says:
>
> 	Adding more to a tracepoint is never an issue, even without a library to
> 	parse the data correctly (which we still need in the distros). Thus this
> 	change should have no issues.
>
>
>
> Oleg Nesterov (2):
>       tracing: let trace_signal_generate() report more info, kill overflow_fail/lose_info
>       tracing: send_sigqueue() needs trace_signal_generate() too
>
>  include/trace/events/signal.h |   85 +++++++++++------------------------------
>  kernel/signal.c               |   28 +++++++++----
>  2 files changed, 41 insertions(+), 72 deletions(-)

