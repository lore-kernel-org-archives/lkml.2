Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab2CEUIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:08:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583Ab2CEUII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:08:08 -0500
Message-ID: <4F551CB6.5010209@redhat.com>
Date: Mon, 05 Mar 2012 15:06:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: use global_dirty_limit in throttle_vm_writeout()
References: <20120302061451.GA6468@localhost>
In-Reply-To: <20120302061451.GA6468@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 01:14 AM, Fengguang Wu wrote:
> When starting a memory hog task, a desktop box w/o swap is found to go
> unresponsive for a long time. It's solely caused by lots of congestion
> waits in throttle_vm_writeout():
>
>   gnome-system-mo-4201 553.073384: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
>   gnome-system-mo-4201 553.073386: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
>             gtali-4237 553.080377: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
>             gtali-4237 553.080378: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
>              Xorg-3483 553.103375: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
>              Xorg-3483 553.103377: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
>
> The root cause is, the dirty threshold is knocked down a lot by the
> memory hog task. Fixed by using global_dirty_limit which decreases
> gradually on such events and can guarantee we stay above (the also
> decreasing) nr_dirty in the progress of following down to the new
> dirty threshold.
>
> Signed-off-by: Fengguang Wu<fengguang.wu@intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

