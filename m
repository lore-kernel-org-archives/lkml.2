Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2KMXLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:11:50 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35789 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2KMXLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:11:49 -0500
Date: Tue, 13 Nov 2012 15:11:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andy Lutomirski <luto@amacapital.net>
cc: Marc Duponcheel <marc@offline.be>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [3.6 regression?] THP + migration/compaction livelock (I
 think)
In-Reply-To: <CALCETrVgbx-8Ex1Q6YgEYv-Oxjoa1oprpsQE-Ww6iuwf7jFeGg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1211131507370.17623@chino.kir.corp.google.com>
References: <CALCETrVgbx-8Ex1Q6YgEYv-Oxjoa1oprpsQE-Ww6iuwf7jFeGg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Andy Lutomirski wrote:

> I've seen an odd problem three times in the past two weeks.  I suspect
> a Linux 3.6 regression.  I"m on 3.6.3-1.fc17.x86_64.  I run a parallel
> compilation, and no progress is made.  All cpus are pegged at 100%
> system time by the respective cc1plus processes.  Reading
> /proc/<pid>/stack shows either
> 
> [<ffffffff8108e01a>] __cond_resched+0x2a/0x40
> [<ffffffff8114e432>] isolate_migratepages_range+0xb2/0x620
> [<ffffffff8114eba4>] compact_zone+0x144/0x410
> [<ffffffff8114f152>] compact_zone_order+0x82/0xc0
> [<ffffffff8114f271>] try_to_compact_pages+0xe1/0x130
> [<ffffffff816143db>] __alloc_pages_direct_compact+0xaa/0x190
> [<ffffffff81133d26>] __alloc_pages_nodemask+0x526/0x990
> [<ffffffff81171496>] alloc_pages_vma+0xb6/0x190
> [<ffffffff81182683>] do_huge_pmd_anonymous_page+0x143/0x340
> [<ffffffff811549fd>] handle_mm_fault+0x27d/0x320
> [<ffffffff81620adc>] do_page_fault+0x15c/0x4b0
> [<ffffffff8161d625>] page_fault+0x25/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> or
> 
> [<ffffffffffffffff>] 0xffffffffffffffff
> 

This reminds me of the thread at http://marc.info/?t=135102111800004 which 
caused Marc's system to reportedly go unresponsive like your report but in 
his case it also caused a reboot.  If your system is still running (or, 
even better, if you're able to capture this happening in realtime), could 
you try to capture

	grep -E "compact_|thp_" /proc/vmstat

as well while it is in progress?  (Even if it's not happening right now, 
the data might still be useful if you have knowledge that it has occurred 
since the last reboot.)
