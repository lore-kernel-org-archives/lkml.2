Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0JTChF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:37:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55238 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab0JTChC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:37:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH 2/2] mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
Cc: kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1010191208130.15499@chino.kir.corp.google.com>
References: <20101019140955.A1EE.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1010191208130.15499@chino.kir.corp.google.com>
Message-Id: <20101020113613.181E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Oct 2010 11:36:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 19 Oct 2010, KOSAKI Motohiro wrote:
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 14ee899..222d8cc 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -51,6 +51,7 @@
> >  #include <linux/kmemleak.h>
> >  #include <linux/memory.h>
> >  #include <linux/compaction.h>
> > +#include <linux/vmstat.h>
> >  #include <trace/events/kmem.h>
> >  #include <linux/ftrace_event.h>
> >  
> > @@ -5013,6 +5014,8 @@ int __meminit init_per_zone_wmark_min(void)
> >  		min_free_kbytes = 128;
> >  	if (min_free_kbytes > 65536)
> >  		min_free_kbytes = 65536;
> > +
> > +	refresh_zone_stat_thresholds();
> >  	setup_per_zone_wmarks();
> >  	setup_per_zone_lowmem_reserve();
> >  	setup_per_zone_inactive_ratio();
> 
> setup_per_zone_wmarks() could change the min and low watermarks for a zone 
> when refresh_zone_stat_thresholds() would have used the old value.

Good catch. thanks.

my previous version removed zone->percpu_drift_mark completely. but
current one doesn't. so I need to fix this.





