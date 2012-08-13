Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2HMOrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:47:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:41009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2HMOrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:47:16 -0400
Message-ID: <1344869225.31459.34.camel@twins>
Subject: Re: [RFC][PATCH 4/4] perf/events: Use helper functions in event
 assignment to shrink macro size
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 13 Aug 2012 16:47:05 +0200
In-Reply-To: <1344868844.6935.121.camel@gandalf.stny.rr.com>
References: <20120810034302.758092203@goodmis.org>
	 <20120810034708.589220175@goodmis.org> <1344845024.31459.9.camel@twins>
	 <1344863027.6935.111.camel@gandalf.stny.rr.com>
	 <1344865977.31459.26.camel@twins>
	 <1344868844.6935.121.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 10:40 -0400, Steven Rostedt wrote:
> > Yeah.. I think you're referring to the {u,k}probes open-coded nonsense?
> > Should we make those use these new helpers you created as well?
> 
> They may not need it. The helpers I created were for the macros that are
> created by all TRACE_EVENT() instances. If the uprobes and kprobes only
> have a single instance, then they probably don't need the helpers. But
> they still call the perf_trace_buf_submit(), which can can probably be
> cleaned up. 

Right, I realize that. I was just thinking it might be good to keep all
(3?) copies similar. Also avoiding two sets of wrappers seems like a
good idea.

