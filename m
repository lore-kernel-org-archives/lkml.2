Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2E2J6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:58:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab2E2J6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:58:31 -0400
Date: Tue, 29 May 2012 11:58:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: Use compound page head in migrate_huge_page
Message-ID: <20120529095827.GC15293@tiehlicka.suse.cz>
References: <1338218490-30978-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120528191322.GA10071@tiehlicka.suse.cz>
 <87obp7u13r.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obp7u13r.fsf@skywalker.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-05-12 08:48:00, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko@suse.cz> writes:
> 
> > On Mon 28-05-12 20:51:30, Aneesh Kumar K.V wrote:
> >> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> >> 
> >> The change was introduced by "hugetlb: simplify migrate_huge_page() "
> >> 
> >> We should use compound page head instead of tail pages in
> >> migrate_huge_page().
> >> 
> >> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> >> ---
> >>  mm/memory-failure.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >> 
> >> This is an important bug fix. If we want we can fold it with the not
> >> yet merged upstream patch mentioned above in linux-next. The stack
> >> trace for the crash is
> >> 
> >> [   75.337421] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> >> [   75.338386] IP: [<ffffffff816b3f0f>] __mutex_lock_common+0xa1/0x350
> >> [   75.338386] PGD 1d700067 PUD 1d7dd067 PMD 0
> >> [   75.338386] Oops: 0002 [#1] SMP
> >> [   75.338386] CPU 1
> >> [   75.338386] Modules linked in:
> >> ...
> >> ...
> >> 
> >> [   75.338386] Call Trace:
> >> [   75.338386]  [<ffffffff810ffc04>] ? try_to_unmap_file+0x38/0x51c
> >> [   75.338386]  [<ffffffff810ffc04>] ? try_to_unmap_file+0x38/0x51c
> >> [   75.338386]  [<ffffffff813b5f8b>] ? vsnprintf+0x83/0x421
> >> [   75.338386]  [<ffffffff816b427d>] mutex_lock_nested+0x2a/0x31
> >> [   75.338386]  [<ffffffff8110999b>] ? alloc_huge_page_node+0x1d/0x55
> >> [   75.338386]  [<ffffffff810ffc04>] try_to_unmap_file+0x38/0x51c
> >> [   75.338386]  [<ffffffff8110999b>] ? alloc_huge_page_node+0x1d/0x55
> >> [   75.338386]  [<ffffffff810a06b9>] ? arch_local_irq_save+0x9/0xc
> >> [   75.338386]  [<ffffffff816b5e3b>] ? _raw_spin_unlock+0x23/0x27
> >> [   75.338386]  [<ffffffff81100839>] try_to_unmap+0x25/0x3c
> >> [   75.338386]  [<ffffffff810641c2>] ? console_unlock+0x210/0x238
> >> [   75.338386]  [<ffffffff811141e3>] migrate_huge_page+0x8d/0x178
> >
> > This should be part of the changelog.
> 
> I was expecting the patch to be folded back to the existing patch in
> -mm. That is the reason I added stack trace in the notes section so that
> if we decided to keep it as a separate patch we can pull the stack trace
> and add it to commit message.

OK.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
