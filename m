Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331Ab1GMLKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:10:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965021Ab1GMLKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:10:21 -0400
Date: Wed, 13 Jul 2011 12:10:17 +0100
From: Mel Gorman <mgorman@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: page allocator: Reconsider zones for allocation
 after direct reclaim
Message-ID: <20110713111017.GG7529@suse.de>
References: <1310389274-13995-1-git-send-email-mgorman@suse.de>
 <1310389274-13995-4-git-send-email-mgorman@suse.de>
 <4E1CE9FF.3050707@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E1CE9FF.3050707@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 09:42:39AM +0900, KOSAKI Motohiro wrote:
> (2011/07/11 22:01), Mel Gorman wrote:
> > With zone_reclaim_mode enabled, it's possible for zones to be considered
> > full in the zonelist_cache so they are skipped in the future. If the
> > process enters direct reclaim, the ZLC may still consider zones to be
> > full even after reclaiming pages. Reconsider all zones for allocation
> > if direct reclaim returns successfully.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Hmmm...
> 
> I like the concept, but I'm worry about a corner case a bit.
> 
> If users are using cpusets/mempolicy, direct reclaim don't scan all zones.
> Then, zlc_clear_zones_full() seems too aggressive operation.

As the system is likely to be running slow if it is in direct reclaim
that the complexity of being careful about which zone was cleared was
not worth it.

> Instead, couldn't we turn zlc->fullzones off from kswapd?
> 

Which zonelist should it clear (there are two) and when should it
happen? If it clears it on each cycle around balance_pgdat(), there
is no guarantee that it'll be cleared between when direct reclaim
finishes and an attempt is made to allocate.

-- 
Mel Gorman
SUSE Labs
