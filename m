Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0IHUF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:05:57 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:28981 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753632Ab0IHUFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:05:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: tofJJJQVM1kZzumx40uM6m5Z60iperTrNe5l5fKipROf3Rw
 xo.PmwGMJVl84twECxELGOUXhSsYjKDQC579ULGoZt9IrRx6m3HoByVForf6
 nQyar9.ZbTPOC_dYcGd3bxgqT_X2wveAScuZ52qR.HNfrS3InGWMGjzDON_u
 7FdtEwIwXThnXkFC3sByCxELtzYUs2DCxIHpHnLMwn3g1I26YJK1YqZ6mIfs
 OdoMA8igIW0hCAMNIflqBZqpJwuqo
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Sep 2010 15:05:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after direct
 reclaim allocation fails
In-Reply-To: <20100908163956.C930.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009081500070.14871@router.home>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie> <1283504926-2120-4-git-send-email-mel@csn.ul.ie> <20100908163956.C930.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, KOSAKI Motohiro wrote:

> nit: when slub, get_page_from_freelist() failure is frequently happen
> than slab because slub try to allocate high order page at first.
> So, I guess we have to avoid drain_all_pages() if __GFP_NORETRY is passed.

SLAB also tries to allocate higher order pages for many slabs but not as
high as SLUB (SLAB does not support fallback to order 0). SLAB also always
uses GFP_THISNODE (which include GFP_NORETRY).

Your patch will make SLAB's initial call to the page allocator fail more
frequently and therefore will increase the use of fallback_alloc().
