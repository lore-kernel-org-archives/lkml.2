Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0F1Bjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 21:39:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47598 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0F1Bjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 21:39:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: recalculate lru_pages on each priority
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20100627113422.GA14504@cmpxchg.org>
References: <20100625181221.805A.A69D9226@jp.fujitsu.com> <20100627113422.GA14504@cmpxchg.org>
Message-Id: <20100628103828.3873.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Jun 2010 10:39:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jun 25, 2010 at 06:13:20PM +0900, KOSAKI Motohiro wrote:
> > shrink_zones() need relatively long time. and lru_pages can be
> > changed dramatically while shrink_zones().
> > then, lru_pages need recalculate on each priority.
> 
> In the direct reclaim path, we bail out of that loop after
> SWAP_CLUSTER_MAX reclaimed pages, so in this case, decreasing priority
> levels actually mean we do _not_ make any progress and the total
> number of lru pages should not change (much).  The possible distortion
> in shrink_slab() is small.

Oh, you seems forgot the case when much thread enter try_to_free_pages()
concurrently.

> 
> However, for the suspend-to-disk case the reclaim target can be a lot
> higher and we inevitably end up at higher priorities even though we
> make progress, but fail to increase pressure on the shrinkers as well
> without your patch.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>



