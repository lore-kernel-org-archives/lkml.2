Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2GKFl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:41:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47051 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2GKFl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:41:26 -0400
Date: Tue, 10 Jul 2012 22:33:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] mm: Warn about costly page allocation
In-Reply-To: <20120711022304.GA17425@bbox>
Message-ID: <alpine.DEB.2.00.1207102223000.26591@chino.kir.corp.google.com>
References: <1341878153-10757-1-git-send-email-minchan@kernel.org> <20120709170856.ca67655a.akpm@linux-foundation.org> <20120710002510.GB5935@bbox> <alpine.DEB.2.00.1207101756070.684@chino.kir.corp.google.com> <20120711022304.GA17425@bbox>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Minchan Kim wrote:

> > Should we consider enabling CONFIG_COMPACTION in defconfig?  If not, would 
> 
> I hope so but Mel didn't like it because some users want to have a smallest
> kernel if they don't care of high-order allocation.
> 

CONFIG_COMPACTION adds 0.1% to my kernel image using x86_64 defconfig, 
that's the only reason we don't enable it by default?

> > it be possible with a different extfrag_threshold (and more aggressive 
> > when things like THP are enabled)?
> 
> Anyway, we should enable compaction for it although the system doesn't 
> care about high-order allocation and it ends up make bloting kernel unnecessary.
> 

The problem with this approach (and the appended patch) is that we can't 
define a system that "doesn't care about high-order allocations."  Even if 
you discount thp, an admin has no way of knowing how many high-order 
allocations his or her kernel will be doing and it will change between 
kernel versions.  Almost 50% of slab caches on my desktop machine running 
with slub have a default order greater than 0.

So I don't believe that adding this warning will be helpful and will 
simply lead to confusion.

> I tend to agree Andrew and your concern but I don't have a good idea but
> alert vague warning message. Anyway, we need *alert* this fact which removed
> lumpy reclaim for being able to disabling CONFIG_COMPACTION.

Can we ignore the fact that lumpy reclaim was removed and look at 
individual issues as they arise and address them by fixing the VM or by 
making a case for enabling CONFIG_COMPACTION by default?
