Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697Ab2FDUwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:52:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:34895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab2FDUwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:52:32 -0400
Message-ID: <1338843134.28282.145.camel@twins>
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: Andrew Vagin <avagin@openvz.org>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 22:52:14 +0200
In-Reply-To: <4FCCE9F5.9050808@fb.com>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
	 <1338813658.28282.43.camel@twins> <4FCCE9F5.9050808@fb.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 10:01 -0700, Arun Sharma wrote:
> On 6/4/12 5:40 AM, Peter Zijlstra wrote:
> 
> > And as a result you need that hideous prev_state crap.
> >
> >
> > Would something like the below work?
> >
> > The one thing I'm not entirely sure of is if this is a sekjoerity issue
> > or not.. anybody? I would think a task was entitled to know who woke it
> > and wherefrom etc..
> 
> Frederic had some comments on this topic in the last round:
> 
> http://thread.gmane.org/gmane.linux.kernel/1195368/focus=1195959
> 
>  > We should probably avoid the remote callchains, sounds like asking 
> for complications everywhere.
> 
> Do they still apply? Frederic?

Probably, but note that the approaches are slightly different. The
previous thing would wreck the callchain for everybody, the proposed
thing will make more events.

Also, you don't need the callchain on the wakeup side of things. You
only want the callchain of the sched_switch site.

We could even dis-allow the callchain unwind when event->ctx->task &&
event->ctx->task != current -- pretend the unwind failed by writing 0
entries.

That also avoids the 'difficultly' of exposing and trying to interpret
another task's callchain.
