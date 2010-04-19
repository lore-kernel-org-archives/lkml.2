Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0DSVKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:10:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45829 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0DSVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:10:29 -0400
X-Authority-Analysis: v=1.1 cv=LStmOzECkPR9xsMk4mw8zTEuC0H5p2ZSOXz5TIvtHNE= c=1 sm=0 a=zBnlsAAkvaYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=B-W9n4AvqdAUgjFdgaIA:9 a=AWPJNsqzaCEyysYnk2x8l1_oUBkA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: request to add trace off and trace on with events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: "Bird, Tim" <Timothy.Bird@am.sony.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BCCC392.3090509@am.sony.com>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>
	 <4BCCBF6D.3030105@am.sony.com>
	 <1271709846.10448.29.camel@gandalf.stny.rr.com>
	 <4BCCC392.3090509@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 17:10:27 -0400
Message-ID: <1271711427.10448.69.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 13:56 -0700, Tim Bird wrote:

> I'm not sure either.  In general I dislike proliferating
> pseudo-files.  But if the tracing filter conditional is
> different from the trigger conditional, it might be needed
> to have something separate.

I was thinking of keeping the filter trigger the trigger too.

I think we talked about this in the past. Where the "trigger" file would
default be print, but could also add other triggers to it. Thus, you do
not need to print when the event is hit (with filters). I think I
originally called this a "command", but multiple commands could perform
this.

> 
> In KFT there were some non-event related trigger conditionals,
> like - start tracing after 20 milliseconds and stop after
> 80 milliseconds.
> 
> Another thing I considered for KFT triggers, but didn't get
> around to implementing, was countdown triggers - such as
> "start tracing on the 5th execution of do_fork".
> 
> With the function or function_graph tracer, since the buffer
> overflows quickly, these kinds of triggered trace starts and stops
> can help pinpoint the data you need.

Try:

echo 'try_to_wake_up:traceon:5' 'schedule:traceoff:5' > set_ftrace_filter

;-)

-- Steve


