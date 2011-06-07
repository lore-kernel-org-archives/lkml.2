Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1FGSoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:44:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1FGSoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:44:05 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=z-YF9ztHd7oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=MQW2Mx4TWi9994kDt_YA:9 a=F5P0s9WokvDZBxbZaBQA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/3] kprobes/trace: Fix kprobe selftest for gcc 4.6
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
In-Reply-To: <4DEE6C82.4000901@caviumnetworks.com>
References: <20110607170740.235441001@goodmis.org>
	 <20110607170827.295368694@goodmis.org>  <4DEE6903.9010501@gmail.com>
	 <1307470377.9218.3.camel@gandalf.stny.rr.com>
	 <4DEE6C82.4000901@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Jun 2011 14:44:03 -0400
Message-ID: <1307472243.9218.10.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 11:22 -0700, David Daney wrote:
> On 06/07/2011 11:12 AM, Steven Rostedt wrote:
> > On Tue, 2011-06-07 at 11:08 -0700, David Daney wrote:
> >
> >>> -static int kprobe_trace_selftest_target(int a1, int a2, int a3,
> >>> -					int a4, int a5, int a6)
> >>> +/*
> >>> + * Can't be static, otherwise gcc might optimize this to
> >>> + * not be in the kallsyms table.
> >>> + */
> >>
> >> Could you make it '__used' instead?
> >>
> >
> > I can try, but the problem is not that the function itself is being
> > optimized out. It looks like its being turned into anonymous text. That
> > is, it optimized out the symbol name, not the code itself.
> >
> 
> Really it is no big deal either way.  Just a thought I had.

This actually works! I like it better.

Ingo, can you hold off on pulling, while I rebase to do it David's way?
I can add tested-by tags and fix misspellings of my other change logs as
well.

Thanks!

-- Steve


