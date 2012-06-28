Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2F1BSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:18:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60639 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2F1BSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:18:42 -0400
X-AuditID: 9c930179-b7cceae000004195-bd-4febb0efb96c
Message-ID: <4FEBB0FA.2070203@kernel.org>
Date: Thu, 28 Jun 2012 10:18:50 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel,gmane.comp.file-systems.ceph.devel
To: David Rientjes <rientjes@google.com>
CC: Rik van Riel <riel@redhat.com>, Jim Schutt <jaschut@sandia.gov>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: excessive CPU utilization by isolate_freepages?
References: <4FEB8237.6030402@sandia.gov> <4FEB9E73.5040709@kernel.org> <4FEBA520.4030205@redhat.com> <alpine.DEB.2.00.1206271745170.9552@chino.kir.corp.google.com> <4FEBAC42.3030800@kernel.org> <alpine.DEB.2.00.1206271803280.10830@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206271803280.10830@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 10:06 AM, David Rientjes wrote:

> On Thu, 28 Jun 2012, Minchan Kim wrote:
> 
>>>>>>> https://lkml.org/lkml/2012/6/21/30
>>>>>
>>> Not sure if Jim is using memcg; if not, then this won't be helpful.
>>>
>>
>>
>> It doesn't related to memcg.
>> if compaction_alloc can't find suitable migration target, it returns NULL.
>> Then, migrate_pages should be exit.
>>
> 
> If isolate_freepages() is going to fail, then this zone should have been 
> skipped when checking for compaction_suitable().  In Jim's perf output, 
> compaction_suitable() returns COMPACT_CONTINUE for a transparent hugepage.  
> Why is zone_watermark_ok(zone, 0 low_wmark + 1024, 0, 0) succeeding if 
> isolate_freepages() is going to fail?
> 


zone_watermark_ok doesn't consider migratetype but suitable_migrate_target
does consider one.

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim
