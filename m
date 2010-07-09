Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0GIODY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:03:24 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:33175 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab0GIODV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:03:21 -0400
Date: Fri, 9 Jul 2010 09:02:31 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: stop meaningless loop iteration when no reclaimable
 slab
In-Reply-To: <20100709191308.FA25.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1007090859560.30663@router.home>
References: <20100708133152.5e556508.akpm@linux-foundation.org> <20100709171850.FA22.A69D9226@jp.fujitsu.com> <20100709191308.FA25.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, KOSAKI Motohiro wrote:

> If number of reclaimable slabs are zero, shrink_icache_memory() and
> shrink_dcache_memory() return 0. but strangely shrink_slab() ignore
> it and continue meaningless loop iteration.

There is also a per zone/node/global counter SLAB_RECLAIM_ACCOUNT that
could be used to determine if its worth looking at things at all. I saw
some effort going into making the shrinkers zone aware. If so then we may
be able to avoid scanning slabs.
