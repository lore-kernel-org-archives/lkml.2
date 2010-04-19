Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0DSUEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:04:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59314 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0DSUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:04:06 -0400
X-Authority-Analysis: v=1.1 cv=LStmOzECkPR9xsMk4mw8zTEuC0H5p2ZSOXz5TIvtHNE= c=1 sm=0 a=CClWbPM6pFEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=Sck7_hbBIXWJDcgNemwA:9 a=Bej4rFqY4zzNahAgF6Ipi6A7P_AA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: request to add trace off and trace on with events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 16:04:04 -0400
Message-ID: <1271707444.10448.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

Could you add a way to do a call to tracing_on() or tracing_off() via
the filters. I would like to do something like:


echo 'if (pid == 1234) traceoff' > events/sched/sched_wakeup/filter

Where, if the sched_wakeup event is hit with pid == 1234 it will turn
tracing off.

I would also like to do just:

echo 'traceoff' > events/sched/sched_wakeup/filter

to disable tracing every time the event is hit.

Perhaps you can just add a call back where the kernel could register
something to be called if a command is used in the filter.

register_event_command("traceoff", trace_off_cb);

where the trace_off_cb is a function that is called by the event if the
traceoff command is hit. This would allow other commands to be added
later.

Would something like this be doable, I was looking at the code, and it
certain looks feasible, but it would take me longer to implement it than
it would you :-)

Thanks,

-- Steve


