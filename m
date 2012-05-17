Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787Ab2EQADg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:03:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41755 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2EQADf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:03:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB43FDB.6050300@jp.fujitsu.com>
Date: Thu, 17 May 2012 09:01:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] mm: memcg: print statistics from live counters
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org> <1337018451-27359-7-git-send-email-hannes@cmpxchg.org> <20120516160131.fecb5ddf.akpm@linux-foundation.org>
In-Reply-To: <20120516160131.fecb5ddf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/17 8:01), Andrew Morton wrote:

> On Mon, 14 May 2012 20:00:51 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
>> Directly print statistics and event counters instead of going through
>> an intermediate accumulation stage into a separate array, which used
>> to require defining statistic items in more than one place.
>>
>> ...
>>
>> -static const char *memcg_stat_strings[NR_MCS_STAT] = {
>> -	"cache",
>> -	"rss",
>> -	"mapped_file",
> 
> Bah humbug, who went and called this mapped_file?
> 
> This stat is derived from MEM_CGROUP_STAT_FILE_MAPPED.  But if we
> rename MEM_CGROUP_STAT_FILE_MAPPED to MEM_CGROUP_STAT_MAPPED_FILE then
> we also need to rename the non-memcg NR_FILE_MAPPED.  And we can't
> change the text to "file_mapped" because it's ABI.
> 


Sorry..

>> -	"mlock",
>> -	"swap",
> 
> And "swap" is derived from MEM_CGROUP_STAT_SWAPOUT.  We could rename
> that to MEM_CGROUP_STAT_SWAP without trouble.
> 

Yes.

> But both are poor names.  There are two concepts here: a) swapout
> events (ie: swap writeout initiation) and b) swapspace usage.  Type a)
> only ever counts up, whereas type b) counts up and down.
> 
> MEM_CGROUP_STAT_SWAPOUT is actually of type b), but "swapout" is a
> misleading term, because it refers to type a) events.
> 

I'll prepare a patch.

> And the human-displayed "swap" is useless because it can refer to
> either type a) or type b) events.  These should be called "swapped" and
> MEM_CGROUP_STAT_SWAPPED.  But we can't change the userspace interface.
> 
> argh, I hate you all!
> 

Hm...sorry. I(fujitsu) am now considering to add meminfo for memcg...,

add an option to override /proc/meminfo if a task is in container or
meminfo file somewhere.
(Now, we cannot trust /usr/bin/free, /usr/bin/top etc...in a container.)

so...I think usual user experience will be better because of the same format
with meminfo.

Thanks,
-Kame


