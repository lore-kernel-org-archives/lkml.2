Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab0ESQea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:34:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:35657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab0ESQe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:34:28 -0400
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1274286434.26328.800.camel@gandalf.stny.rr.com>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>  <20100519072138.GC5704@nowhere>
	 <1274255882.5605.10216.camel@twins>
	 <1274280439.26328.770.camel@gandalf.stny.rr.com>
	 <1274281506.5605.11111.camel@twins>
	 <1274283492.26328.779.camel@gandalf.stny.rr.com>
	 <1274284201.5605.11212.camel@twins>
	 <1274285293.26328.788.camel@gandalf.stny.rr.com>
	 <1274285709.5605.11265.camel@twins>
	 <1274286434.26328.800.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 18:34:04 +0200
Message-ID: <1274286844.5605.11307.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 12:27 -0400, Steven Rostedt wrote:

> OK, so I would let them evaluate separately. If they do have two
> different results, then that's fine, because the view of an event could
> possible be different. The &bar may change in the two instances, but how
> much does that matter? Which version of &bar is correct anyway?

Right, can do, but again, that sucks for filters -- I'm starting to
think we never should have accepted that stuff.

> How do you handle the multiple readers then? The call to record the
> event copies to each buffer that is registered for that event?

Yeah, each perf_event has its own buffer (usually) so we simply generate
multiple events, one for each buffer. The readers, task A and B will get
wakeups once in a while to empty the buffer.

> If more than one buffer is attached to an event, you could also work to
> directly write to one, and then copy directly from that buffer to the
> others.

Yeah, I mentioned this a few emails back, but since you need the keep
the commit open until you've copied it the code can get quite ugly.
