Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2BMWcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:32:05 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35399 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BMWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:32:03 -0500
Date: Mon, 13 Feb 2012 14:31:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, avi@redhat.com,
        nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20120213223156.GG12117@google.com>
References: <20111223014043.GC12738@redhat.com>
 <20111222175834.66559c8b.akpm@linux-foundation.org>
 <20111223025629.GE12738@redhat.com>
 <20111226150531.3c22f2f0.kamezawa.hiroyu@jp.fujitsu.com>
 <20111227175249.GE17712@google.com>
 <20111228091402.c45a08f6.kamezawa.hiroyu@jp.fujitsu.com>
 <20111228004102.GK17712@google.com>
 <20120105012842.GQ31746@google.com>
 <20120209235845.GH19392@google.com>
 <20120210162658.GC3150@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210162658.GC3150@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Fri, Feb 10, 2012 at 11:26:58AM -0500, Vivek Goyal wrote:
> The only difference is that by putting this logic in per cpu counters,
> we make it somewhat generic so that other users who can't do GFP_KERNEL
> allocation of per cpu data, can use it. I can live with that.

Also, it has fallback mechanism while percpu data isn't there, so the
counts are guaranteed to be right.  Probably doesn't matter all that
much for blkcg stats.

> But if you don't think that fixing alloc_percpu() is possible in long
> term and users should use per cpu counters for any kind of non GFP_KERNEL
> needs, then it probably is find to continue to develop this patch.

Updating alloc_percpu() to support full @gfp_mask is rather complex
and likely to generate a lot of churn and fragility.

> Personally, I liked my old patch of restricting worker thread allocation
> logic to blk-throttle.c and cfq-iosched.c. If you don't have objection
> to that approach, I can brush it up, fix a pending issue and post it?

I don't know.  If we're gonna do that, I think doing that in mempool
is better.  Andrew, are you still dead against using mempool for
percpu pooling?  That logic is going somewhere and it probably is
better to put it somewhere common rather than shoving it in block
cgroup code.

Thanks.

-- 
tejun
