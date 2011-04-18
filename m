Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1DROIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:08:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:55438 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab1DROII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:08:08 -0400
Date: Mon, 18 Apr 2011 15:08:04 +0100
From: Mel Gorman <mgorman@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 12/12] mm: Throttle direct reclaimers if PF_MEMALLOC
 reserves are low and swap is backed by network storage
Message-ID: <20110418140804.GC16908@suse.de>
References: <1302777698-28237-1-git-send-email-mgorman@suse.de>
 <1302777698-28237-13-git-send-email-mgorman@suse.de>
 <20110418223251.7ab148bb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110418223251.7ab148bb@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:32:51PM +1000, NeilBrown wrote:
> On Thu, 14 Apr 2011 11:41:38 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > If swap is backed by network storage such as NBD, there is a risk that a
> > large number of reclaimers can hang the system by consuming all
> > PF_MEMALLOC reserves. To avoid these hangs, the administrator must tune
> > min_free_kbytes in advance. This patch will throttle direct reclaimers
> > if half the PF_MEMALLOC reserves are in use as the system is at risk of
> > hanging. A message will be displayed so the administrator knows that
> > min_free_kbytes should be tuned to a higher value to avoid the
> > throttling in the future.
> > 
> 
> (I knew there was something else).
> 
> I understand that there are suggestions that direct reclaim should always be
> serialised as this reduces lock contention and improve data patterns (or
> something like that).
> 

AFAIK, this suggestion never got much beyond the "hand-waving" stage
of development. It tended to trip up on the fact that such a feature
could also throttle processes on machines with plenty of free clean
unmapped pagecache which would be undesirable.

> Would that make this patch redundant? 

Depends on how it was being serialised but ....

> Or does this provide some extra
> guarantee that the other proposal would not?
> 

This patch could be extended to serialise direct reclaims in situations
other than PFMEMALLOC is low if someone demonstrated the benefit.

-- 
Mel Gorman
SUSE Labs
