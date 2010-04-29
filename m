Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab0D2AEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:04:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab0D2AEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:04:13 -0400
X-Authority-Analysis: v=1.1 cv=m27xf9DC4olkrNDaWzGlhfWN1WyLlD0+t5Z5YaFh7bA= c=1 sm=0 a=dt1ycumTCpsA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=KIDW1aQ4dO4FNOyOasUA:9 a=DTguLQ6NoU2-_tYj_6bTxt5FlA4A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 09/10][RFC] tracing: Remove duplicate id information in
 event structure
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100428210642.GJ8591@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200243.649349066@goodmis.org>  <20100428210642.GJ8591@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 28 Apr 2010 20:04:11 -0400
Message-ID: <1272499451.9739.90.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 17:06 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Now that the trace_event structure is embedded in the ftrace_event_call
> > structure, there is no need for the ftrace_event_call id field.
> > The id field is the same as the trace_event type field.
> > 
> > Removing the id and re-arranging the structure brings down the tracepoint
> > footprint by another 5K.
> 
> I might have missed it, but how exactly is the event type allocated
> uniquely ? Is it barely a duplicate of the call "id" field ?

It is allocated in kernel/trace/trace_events.c.

The code there scans the "_ftrace_events" section to find all the events
that are created, and it assigns the events a unique id. Currently the
id is just copied from the trace_event field to the ftrace_event_call
data. The two are the same.

-- Steve


