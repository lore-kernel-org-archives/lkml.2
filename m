Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab1DLPtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:49:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63735 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab1DLPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gRxYOZ6U7yg4kLVP4iHLXlJ/IkDSi99U9pkUMr6qNW6zgX/P6CUFEMOczBHxe81fwk
         GBtSqkZPz0ept7dKYUhmuYo/RcoNhfP1QiyPtTZcJu9K6pupFU3BCEZZmnVkLk5D3xdl
         9Y2IYENu0omjpLyujfSX+bZgxtPiWthg0fsxE=
Date: Tue, 12 Apr 2011 17:48:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: Don't schedule tracepoints when exclude_kernel
 is set
Message-ID: <20110412154850.GA2240@nowhere>
References: <1302296275-26767-1-git-send-email-fweisbec@gmail.com>
 <1302354884.9086.1272.camel@twins>
 <20110409132709.GA1799@nowhere>
 <1302356262.9086.1280.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302356262.9086.1280.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 09, 2011 at 03:37:42PM +0200, Peter Zijlstra wrote:
> On Sat, 2011-04-09 at 15:27 +0200, Frederic Weisbecker wrote:
> > On Sat, Apr 09, 2011 at 03:14:44PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2011-04-08 at 22:57 +0200, Frederic Weisbecker wrote:
> > > > Instead of checking attr.exclude_kernel anytime a tracepoint
> > > > event triggers, simply don't schedule the tracepoint it that
> > > > attribute is set. This makes one test less in the tracing
> > > > path.
> > > 
> > > Meh, I'd much rather someone spend some time on finishing the below,
> > > which is a much bigger improvement for trace-events.
> > 
> > I secretely added that to my pile already :)
> > That's indeed something we really want.
> > 
> > The above is just a little thing I noticed yesterday and I wanted
> > to fix. Nothing more.
> > 
> > About that tracepoint collection, I'm not sure I like the idr though.
> > That thing seems to be O(log(n)), I which we can rather approach O(1)
> > when possible, using a hlist perhaps.
> 
> We only do 2 idr lookups at most and don't get to muck about with hash
> table collisions etc. But if you can show that that is the bottleneck
> you can replace the task/cpu idrs with a hashtable.

We can probably start with the irds to begin with. The implementation
can be enhanced anytime.

> 
> You will still need an IDR to deal with the traceevents (trace_type_idr)
> in order to get the dense ID space, and the per-event idr isn't used in
> the fast path at all.

Yep, no problem with that.
