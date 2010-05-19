Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0ESH63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:58:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab0ESH60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:58:26 -0400
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100519072138.GC5704@nowhere>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>  <20100519072138.GC5704@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 09:58:02 +0200
Message-ID: <1274255882.5605.10216.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 09:21 +0200, Frederic Weisbecker wrote:

> I'm still not sure what you mean here by this multiplexing. Is
> this about per cpu multiplexing?

Suppose there's two events attached to the same tracepoint. Will you
write the tracepoint twice and risk different data in each, or will you
do it once and copy it into each buffer?

> There is another problem. We need something like
> perf_output_discard() in case the filter reject the event (which
> must be filled for this check to happen).

Yeah, I utterly hate that, I opted to let anything with a filter take
the slow path. Not only would I have to add a discard, but I'd have to
decrement the counter as well, which is a big no-no.



