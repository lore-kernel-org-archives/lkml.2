Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2F1BHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:07:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37711 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab2F1BHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:07:01 -0400
Date: Wed, 27 Jun 2012 18:06:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Rik van Riel <riel@redhat.com>, Jim Schutt <jaschut@sandia.gov>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: excessive CPU utilization by isolate_freepages?
In-Reply-To: <4FEBAC42.3030800@kernel.org>
Message-ID: <alpine.DEB.2.00.1206271803280.10830@chino.kir.corp.google.com>
References: <4FEB8237.6030402@sandia.gov> <4FEB9E73.5040709@kernel.org> <4FEBA520.4030205@redhat.com> <alpine.DEB.2.00.1206271745170.9552@chino.kir.corp.google.com> <4FEBAC42.3030800@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012, Minchan Kim wrote:

> >>> > > https://lkml.org/lkml/2012/6/21/30
> >> > 
> > Not sure if Jim is using memcg; if not, then this won't be helpful.
> > 
> 
> 
> It doesn't related to memcg.
> if compaction_alloc can't find suitable migration target, it returns NULL.
> Then, migrate_pages should be exit.
> 

If isolate_freepages() is going to fail, then this zone should have been 
skipped when checking for compaction_suitable().  In Jim's perf output, 
compaction_suitable() returns COMPACT_CONTINUE for a transparent hugepage.  
Why is zone_watermark_ok(zone, 0 low_wmark + 1024, 0, 0) succeeding if 
isolate_freepages() is going to fail?
