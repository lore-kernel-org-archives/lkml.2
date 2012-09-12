Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab2ILNwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:52:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2ILNwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:52:35 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_OcxHUuX9McA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ptxN4nHB2WUA:10 a=6XMzwBSlIxR0NEaJ1EUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347457954.10751.38.camel@gandalf.local.home>
Subject: Re: [PATCH v3] trace: Move trace event enable from fs_initcall to
 core_initcall
From: Steven Rostedt <rostedt@goodmis.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        tim.bird@am.sony.com, Ingo Molnar <mingo@redhat.com>
Date: Wed, 12 Sep 2012 09:52:34 -0400
In-Reply-To: <CALF0-+XxgMsQwwGaody0L5MTwpkDhqukbvzG2fUNsG1hEaREUw@mail.gmail.com>
References: <1347134489-15380-1-git-send-email-elezegarcia@gmail.com>
	 <1347410070.10751.28.camel@gandalf.local.home>
	 <CALF0-+XxgMsQwwGaody0L5MTwpkDhqukbvzG2fUNsG1hEaREUw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 09:29 -0300, Ezequiel Garcia wrote:
> Steven,
> 
> On Tue, Sep 11, 2012 at 9:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> ble(void)
> [...]
> >> +     /*
> >> +      * Early initialization already enabled ftrace event.
> >> +      * Now it's only necessary to create the event directory.
> >> +      */
> >>       for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
> >> -             __trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
> >
> > Here, __trace_add_event_call() did the checks and did not create a
> > directory on raw_init() failure. But now there's no check, and we are
> > having events being created that should not be.
> >
> 
> I believe the problem is we're iterating through every event
> defined in __start_ftrace_events.
> We should iterate through the events added to the ftrace_events list.

Yeah, that sounds like a better solution. I can't at the moment think of
anything where that would break.

Thanks,

-- Steve

