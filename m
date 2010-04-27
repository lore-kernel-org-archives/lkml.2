Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0D0WP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:15:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab0D0WP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:15:57 -0400
X-Authority-Analysis: v=1.1 cv=tamp8Om8S85MB4Qj1n2yU9kNzNdU9gdJUe8fX0YwrYg= c=1 sm=0 a=fwHPyVoetMsA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=kHxYsmtLXozKQCdrlQsA:9 a=ShKVcq6AOtb3Dph1PxkA:7 a=_bhSvZ2zLf5N6QDFT9rWYHJwaCYA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] ftrace: print sample std dev when function profiling
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <y2k40ec3ea41004271406x3727625cwa3c5d628e0e9ad3b@mail.gmail.com>
References: <1272304925-2436-1-git-send-email-chase.douglas@canonical.com>
	 <1272401402.9739.77.camel@gandalf.stny.rr.com>
	 <y2k40ec3ea41004271406x3727625cwa3c5d628e0e9ad3b@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 27 Apr 2010 18:15:54 -0400
Message-ID: <1272406554.9739.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 17:06 -0400, Chase Douglas wrote:
> On Tue, Apr 27, 2010 at 4:50 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 2010-04-26 at 14:02 -0400, Chase Douglas wrote:
> >
> >> +     /* Sample standard deviation (s^2) */
> >> +     if (rec->counter <= 1)
> >> +             stddev = 0;
> >> +     else {
> >> +             stddev = rec->time_squared - rec->counter * avg * avg;
> >> +             do_div(stddev, (rec->counter - 1) * 1000); /* ns^2 -> us^2 */
> >
> > Shouldn't this be:
> >
> >        do_div(stddev, (rec->counter - 1) * 1000000); ?
> >
> > (x / 1000)^2 == x^2 / 1000^2
> 
> The trace_print_graph_duration function divides the value by 1000
> again to display in us units. I could make the comment more clear, but
> I didn't want to make a big fuss over a unit conversion.
> 
> I also figured this out *after* I had some really wrong looking
> numbers :). I made sure this patch produced the correct value after
> two events, so I assume the math is correct.

OK, I see that now. I'll add this patch but I'll also fix the comment.

Thanks,

-- Steve


