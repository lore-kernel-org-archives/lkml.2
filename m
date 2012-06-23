Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2FWPWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 11:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab2FWPWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 11:22:45 -0400
Message-ID: <4FE5DF1E.1030208@redhat.com>
Date: Sat, 23 Jun 2012 11:22:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Zheng Liu <gnehzuil.liu@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: consider all swapped back pages in used-once logic
References: <1337246033-13719-1-git-send-email-mhocko@suse.cz> <20120517195342.GB1800@cmpxchg.org> <20120521025149.GA32375@gmail.com> <20120521073632.GL1406@cmpxchg.org> <20120521085951.GA4687@gmail.com> <20120521093705.GM1406@cmpxchg.org> <20120521110659.GA7143@gmail.com> <20120623110450.GP27816@cmpxchg.org>
In-Reply-To: <20120623110450.GP27816@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 07:04 AM, Johannes Weiner wrote:

> I think we need to go back to protecting mapped pages based on how
> much of reclaimable memory they make up, one way or another.
>
> Minchan suggested recently to have a separate LRU list for easily
> reclaimable pages.  If we balance the lists according to relative
> size, we have pressure on mapped pages dictated by availability of
> clean cache that is easier to reclaim.
>
> Rik, Minchan, what do you think?

I believe the main reclaim balancings should probably be
"cgroup vs cgroup", "anon vs file" and "active vs inactive".

However, there is some room for sorting within the inactive
file list, to ensure we actually have a bunch of easily
reclaimable pages available at all times.

This would not work on the anon side, because there are
workloads that fill up 95% of memory with working set,
but on the file side it could actually solve some real
issues.

-- 
All rights reversed
