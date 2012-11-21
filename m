Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2KUPB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:01:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab2KUPB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:01:57 -0500
Date: Wed, 21 Nov 2012 15:01:50 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC 3/3] man-pages: Add man page for vmpressure_fd(2)
Message-ID: <20121121150149.GE8218@suse.de>
References: <20121107105348.GA25549@lizard>
 <20121107110152.GC30462@lizard>
 <20121119215211.6370ac3b.akpm@linux-foundation.org>
 <20121120062400.GA9468@lizard>
 <alpine.DEB.2.00.1211201004390.4200@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211201004390.4200@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:12:28AM -0800, David Rientjes wrote:
> On Mon, 19 Nov 2012, Anton Vorontsov wrote:
> 
> > We try to make userland freeing resources when the system becomes low on
> > memory. Once we're short on memory, sometimes it's better to discard
> > (free) data, rather than let the kernel to drain file caches or even start
> > swapping.
> > 
> 
> To add another usecase: its possible to modify our version of malloc (or 
> any malloc) so that memory that is free()'d can be released back to the 
> kernel only when necessary, i.e. when keeping the extra memory around 
> starts to have a detremental effect on the system, memcg, or cpuset.  When 
> there is an abundance of memory available such that allocations need not 
> defragment or reclaim memory to be allocated, it can improve performance 
> to keep a memory arena from which to allocate from immediately without 
> calling the kernel.
> 

A potential third use case is a variation of the first for batch systems. If
it's running low priority tasks and a high priority task starts that
results in memory pressure then the job scheduler may decide to move the
low priority jobs elsewhere (or cancel them entirely).

A similar use case is monitoring systems running high priority workloads
that should never swap. It can be easily detected if the system starts
swapping but a pressure notification might act as an early warning system
that something is happening on the system that might cause the primary
workload to start swapping.

-- 
Mel Gorman
SUSE Labs
