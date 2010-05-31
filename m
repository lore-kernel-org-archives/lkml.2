Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0EaIys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:54:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0EaIyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:54:47 -0400
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1275293544.27810.21478.camel@twins>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
	 <1275059710.27810.9624.camel@twins>  <20100531080049.GA435@elte.hu>
	 <1275293544.27810.21478.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 10:54:59 +0200
Message-ID: <1275296099.27810.21622.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 10:12 +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-31 at 10:00 +0200, Ingo Molnar wrote:
> > > 
> > > NAK, aside from a few corner cases wakeup and sleep are the important 
> > > points.
> > > 
> > > The activate and deactivate functions are implementation details.
> > 
> > Frederic, can you show us a concrete example of where we dont know what is 
> > going on due to inadequate instrumentation? Can we fix that be extending the 
> > existing tracepoints? 
> 
> Right, so a few of those corner cases I mentioned above are things like
> re-nice, PI-boosts etc.. Those use deactivate, modify task-state,
> activate cycles. so if you want to see those, we can add an explicit
> tracepoint for those actions.
> 
> An explicit nice/PI-boost tracepoint is much clearer than trying to
> figure out wth the deactivate/activate cycle was for.

Another advantage of explicit tracepoints is that you'd see them even
for non-running tasks, because we only do the deactivate/activate thingy
for runnable tasks.


