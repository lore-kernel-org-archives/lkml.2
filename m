Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0CQOAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:00:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab0CQOAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:00:38 -0400
Date: Wed, 17 Mar 2010 09:59:36 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100317135936.GA2659@redhat.com>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <20100317095230.GD17146@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317095230.GD17146@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 10:52:30AM +0100, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > You add chained indirect calls into all lock ops, that's got to hurt.
> > 
> > Well, the idea was not bad at the first glance. It was separating lockdep 
> > and lock events codes.
> > 
> > But indeed, the indirect calls plus the locking are not good for such a fast 
> > path.
> 
> What would be nice to have is some sort of dynamic patching approach to enable 
> _both_ lockdep, lockstat and perf lock.
> 

right. this would allow distros to ship lockdep, lockstat in their
default kernels as a runtime option.


> If TRACE_EVENT() tracepoints were patchable we could use them. (but they arent 
> right now)
> 

right. I'm going to re-post the jump labeling work again soon, which
implicitly makes all TRACE_EVENT() tracepoints into dynamic patch
points. The jump label approach can also be deployed independently of
the tracepoints.

Also, any hints, suggestions on where to start with this type of
project? I thought a lot of the lockdep overhead was tied up in the data
structures? If its just a matter of identifying the dynamic patch
points. I can convert them to jump label and run benchmarks, pretty
easily.

thanks,

-Jason





