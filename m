Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935244Ab0KQS3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:29:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40339 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab0KQS3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:29:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nh+MYqXOXEHjAehwh1XsUGrpBiNU5DLnI243iRDO6t2Q1tBhENaZl/acWOciej6HHA
         FAj6F11Chl4VSO9svmlMoGkG5H6AotUf5zVIQG3oGt9IJrn5iklpdIGeknsQh4pYhtLt
         J9SxcaiJc9al3L1nalTR24+85Woo4wehAwX68=
Date: Wed, 17 Nov 2010 19:29:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117182859.GB5352@nowhere>
References: <20101117083020.GA11336@elte.hu> <1289993750.2109.718.camel@laptop> <20101117125344.GC5464@nowhere> <1289998957.2109.751.camel@laptop> <20101117131023.GE27063@elte.hu> <1290000976.2109.782.camel@laptop> <20101117134300.GG5464@nowhere> <1290002029.2109.799.camel@laptop> <20101117141031.GH5464@nowhere> <20101117181340.GF3290@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117181340.GF3290@thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 01:13:40PM -0500, Ted Ts'o wrote:
> On Wed, Nov 17, 2010 at 03:10:33PM +0100, Frederic Weisbecker wrote:
> > Yeah I have a strange workflow. I'm working on that CPU isolation thing
> > and I have dozens of trace_printk all over the place for tons of
> > things. And everytime I remove one to unwind some output or to focus
> > on another one, I often have to restore it later because I need it
> > again. Usually I even just comment it out instead of removing it.
> 
> What I do for my file system development work is to drop in
> trace_printk's everywhere, since they are lightweight and don't slow
> down the system much.  Then when the system wedges, I use sysrq-z to
> get a "flight data recorder" printout of what happened up til the
> system hung.
> 
> I love the fact that the ring buffer is in "overwrite" mode (aka
> flight data recorder mode), and hope this doesn't go away.
> 
> Per line filtering is also great, but very often when I'm interacting
> with the block I/O layer, if something screws up, what happens is "and
> then whole machine locks up", and sysrq-z is literally all I have. 

Yeah all agreed.

Steve proposed to keep the current trace_printk() implementation that relies
on ftrace but rename in into ftrace_printk(). So that we can develop a new
trace_printk() based on trace_event interface and in the meantime keep the
old version in case something messes up with the new thing.

