Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab0KOPEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:04:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0KOPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:04:20 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=5z8Dt6at09oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=xddf3oqfGB7WRf4jx_0A:9 a=yIBb9tV09Hcva7BPi3gA:7 a=Xu8_-e17MXfywD8l-0Hx04VBrh4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
 x86 & x86_64
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu, lwoodman@redhat.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101115145359.GC5410@nowhere>
References: <20101110164413.GA5360@nowhere>
	 <1289466549-7602-3-git-send-email-jolsa@redhat.com>
	 <20101115134325.GA5410@nowhere> <20101115140632.GI7269@basil.fritz.box>
	 <20101115145359.GC5410@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 15 Nov 2010 10:04:18 -0500
Message-ID: <1289833458.12418.601.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 15:54 +0100, Frederic Weisbecker wrote:
> On Mon, Nov 15, 2010 at 03:06:33PM +0100, Andi Kleen wrote:

> > For tracing the whole page fault me think it's better to have 
> > a generalized exception tracer with a filter on page fault.
> 
> 
> You're right. A tracepoint in handle_mm_fault() would be perhaps
> better. It should catch most tracepoints the users are interested
> in. On the other hand we may miss part of the page fault
> latency, like the mmap_sem contention. This can be measured using
> lock events though.
> 
> But I'm probably missing other important things.

I would have the general exception handler as a tracepoint that would
have a "stable tracepoint" hook to it. That is, when enabling it as a
infield debugging tracepoint, we would get the "raw tracepoint", but the
stable tracepoint would massage it into different general types of
exceptions, and the code there would do the filtering.

-- Steve


