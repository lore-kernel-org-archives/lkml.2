Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2F1Azl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 20:55:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54876 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2F1Azk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 20:55:40 -0400
X-AuditID: 9c93016f-b7cc1ae00000555f-1b-4febab87f1e6
Message-ID: <4FEBAB92.4090206@kernel.org>
Date: Thu, 28 Jun 2012 09:55:46 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.comp.file-systems.ceph.devel,gmane.linux.kernel.mm,gmane.linux.kernel
To: Rik van Riel <riel@redhat.com>
CC: Jim Schutt <jaschut@sandia.gov>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: excessive CPU utilization by isolate_freepages?
References: <4FEB8237.6030402@sandia.gov> <4FEB9E73.5040709@kernel.org> <4FEBA520.4030205@redhat.com>
In-Reply-To: <4FEBA520.4030205@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:28 AM, Rik van Riel wrote:

> On 06/27/2012 07:59 PM, Minchan Kim wrote:
> 
>> I doubt compaction try to migrate continuously although we have no
>> free memory.
>> Could you apply this patch and retest?
>>
>> https://lkml.org/lkml/2012/6/21/30
> 
> Another possibility is that compaction is succeeding every time,
> but since we always start scanning all the way at the beginning
> and end of each zone, we waste a lot of CPU time rescanning the
> same pages (that we just filled up with moved pages) to see if
> any are free.


It does make sense.

> 
> In short, due to the way compaction behaves right now,
> compaction + isolate_freepages are essentially quadratic.
> 
> What we need to do is remember where we left off after a
> successful compaction, so we can continue the search there
> at the next invocation.
> 


Good idea.
It could enhance parallel compaction, too.
Of course, if we can't meet the goal, we need loop around from start/end of zone.

-- 
Kind regards,
Minchan Kim
