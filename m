Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1DINiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 09:38:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:44143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1DINh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 09:37:59 -0400
Subject: Re: [PATCH] perf: Don't schedule tracepoints when exclude_kernel
 is set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20110409132709.GA1799@nowhere>
References: <1302296275-26767-1-git-send-email-fweisbec@gmail.com>
	 <1302354884.9086.1272.camel@twins>  <20110409132709.GA1799@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Apr 2011 15:37:42 +0200
Message-ID: <1302356262.9086.1280.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-09 at 15:27 +0200, Frederic Weisbecker wrote:
> On Sat, Apr 09, 2011 at 03:14:44PM +0200, Peter Zijlstra wrote:
> > On Fri, 2011-04-08 at 22:57 +0200, Frederic Weisbecker wrote:
> > > Instead of checking attr.exclude_kernel anytime a tracepoint
> > > event triggers, simply don't schedule the tracepoint it that
> > > attribute is set. This makes one test less in the tracing
> > > path.
> > 
> > Meh, I'd much rather someone spend some time on finishing the below,
> > which is a much bigger improvement for trace-events.
> 
> I secretely added that to my pile already :)
> That's indeed something we really want.
> 
> The above is just a little thing I noticed yesterday and I wanted
> to fix. Nothing more.
> 
> About that tracepoint collection, I'm not sure I like the idr though.
> That thing seems to be O(log(n)), I which we can rather approach O(1)
> when possible, using a hlist perhaps.

We only do 2 idr lookups at most and don't get to muck about with hash
table collisions etc. But if you can show that that is the bottleneck
you can replace the task/cpu idrs with a hashtable.

You will still need an IDR to deal with the traceevents (trace_type_idr)
in order to get the dense ID space, and the per-event idr isn't used in
the fast path at all.


