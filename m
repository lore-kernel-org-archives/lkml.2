Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915Ab2BOPnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:43:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab2BOPnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:43:50 -0500
Date: Wed, 15 Feb 2012 10:43:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, avi@redhat.com,
        nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20120215154341.GB27312@redhat.com>
References: <20111222175834.66559c8b.akpm@linux-foundation.org>
 <20111223025629.GE12738@redhat.com>
 <20111226150531.3c22f2f0.kamezawa.hiroyu@jp.fujitsu.com>
 <20111227175249.GE17712@google.com>
 <20111228091402.c45a08f6.kamezawa.hiroyu@jp.fujitsu.com>
 <20111228004102.GK17712@google.com>
 <20120105012842.GQ31746@google.com>
 <20120209235845.GH19392@google.com>
 <20120210162658.GC3150@redhat.com>
 <20120213223156.GG12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213223156.GG12117@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 02:31:56PM -0800, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Fri, Feb 10, 2012 at 11:26:58AM -0500, Vivek Goyal wrote:
> > The only difference is that by putting this logic in per cpu counters,
> > we make it somewhat generic so that other users who can't do GFP_KERNEL
> > allocation of per cpu data, can use it. I can live with that.
> 
> Also, it has fallback mechanism while percpu data isn't there, so the
> counts are guaranteed to be right.  Probably doesn't matter all that
> much for blkcg stats.

Ok, I had missed that part. Nice.

I have no objections to making this lazy allocation in per cpu counter
idea work and migrate blkcg per cpu stats to use per cpu counters. If
this patchset is not too intrusive, it might even be backportable to
stable kernels.

Andrew does not seem to like mempool idea, so instead of not making
any progress, it is better to go with this idea. We need to fix this
issue. More poeple might run into this.

Thanks
Vivek
