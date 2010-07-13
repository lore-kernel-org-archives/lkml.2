Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab0GME7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:59:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52135 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0GME7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:59:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] vmscan: stop meaningless loop iteration when no reclaimable slab
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.2.00.1007090859560.30663@router.home>
References: <20100709191308.FA25.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1007090859560.30663@router.home>
Message-Id: <20100713135817.EA4F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Jul 2010 13:59:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 9 Jul 2010, KOSAKI Motohiro wrote:
> 
> > If number of reclaimable slabs are zero, shrink_icache_memory() and
> > shrink_dcache_memory() return 0. but strangely shrink_slab() ignore
> > it and continue meaningless loop iteration.
> 
> There is also a per zone/node/global counter SLAB_RECLAIM_ACCOUNT that
> could be used to determine if its worth looking at things at all. I saw
> some effort going into making the shrinkers zone aware. If so then we may
> be able to avoid scanning slabs.

Yup.
After to merge nick's effort, we can makes more imrovement. I bet :)




