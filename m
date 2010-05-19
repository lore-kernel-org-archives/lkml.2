Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0ESQPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:15:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:57935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0ESQPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:15:42 -0400
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1274285293.26328.788.camel@gandalf.stny.rr.com>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>  <20100519072138.GC5704@nowhere>
	 <1274255882.5605.10216.camel@twins>
	 <1274280439.26328.770.camel@gandalf.stny.rr.com>
	 <1274281506.5605.11111.camel@twins>
	 <1274283492.26328.779.camel@gandalf.stny.rr.com>
	 <1274284201.5605.11212.camel@twins>
	 <1274285293.26328.788.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 18:15:09 +0200
Message-ID: <1274285709.5605.11265.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 12:08 -0400, Steven Rostedt wrote:
> > Now suppose you have multiple active consumers of the tracepoint, either
> > you do the evaluation once and copy that around, or you do it multiple
> > times and end up with different results.
> 
> OK, this is where I'm getting a bit lost. The "multiple active
> consumers". Is this multiple instances of perf? Or perf doing multiple
> things with that event using different buffers? 

Multiple perf events of the same tracepoint, basically what you would en
up with if you were to allow multiple buffers.

Say task A and B both sample C's sched:sched_wakeup events. Then the
tracepoint will have two active perf_events hanging from it and we need
to fill two buffers.


