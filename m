Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab2CSHhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:37:38 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59613 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2CSHhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:37:36 -0400
Date: Mon, 19 Mar 2012 08:37:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: use global_dirty_limit in throttle_vm_writeout()
Message-ID: <20120319073713.GC1841@cmpxchg.org>
References: <20120302061451.GA6468@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302061451.GA6468@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 02:14:51PM +0800, Fengguang Wu wrote:
> When starting a memory hog task, a desktop box w/o swap is found to go
> unresponsive for a long time. It's solely caused by lots of congestion
> waits in throttle_vm_writeout():
> 
>  gnome-system-mo-4201 553.073384: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
>  gnome-system-mo-4201 553.073386: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
>            gtali-4237 553.080377: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
>            gtali-4237 553.080378: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
>             Xorg-3483 553.103375: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
>             Xorg-3483 553.103377: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
> 
> The root cause is, the dirty threshold is knocked down a lot by the
> memory hog task. Fixed by using global_dirty_limit which decreases
> gradually on such events and can guarantee we stay above (the also
> decreasing) nr_dirty in the progress of following down to the new
> dirty threshold.
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
