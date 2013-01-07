Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3AGPh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:37:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3AGPh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:37:27 -0500
Date: Mon, 7 Jan 2013 15:37:23 +0000
From: Mel Gorman <mgorman@suse.de>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 44/49] mm: numa: Add THP migration for the NUMA working
 set scanning fault case.
Message-ID: <20130107153723.GN3885@suse.de>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
 <1354875832-9700-45-git-send-email-mgorman@suse.de>
 <20130105084229.GA3208@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130105084229.GA3208@hacker.(null)>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 04:42:29PM +0800, Wanpeng Li wrote:
> >+int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
> >+{
> >+	int ret = 0;
> >
> > 	/* Avoid migrating to a node that is nearly full */
> > 	if (migrate_balanced_pgdat(pgdat, 1)) {
> 
> Hi Mel Gorman,
> 
> This parameter nr_migrate_pags = 1 is not correct, since balancenuma also 
> support THP in this patchset, the parameter should be 1 <= compound_order(page) 
> instead of 1. I'd rather change to something like:
> 

True. The impact is marginal because it only applies when a node is almost
full but it does mean that we do some unnecessary work before migration
fails anyway. I've added a TODO item to fix it when I next revisit NUMA
balancing. Thanks.

-- 
Mel Gorman
SUSE Labs
