Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0KIK1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:27:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47389 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0KIK1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:27:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 61 of 66] use compaction for GFP_ATOMIC order > 0
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <b540c09bfe5160120952.1288798116@v2.random>
References: <patchbomb.1288798055@v2.random> <b540c09bfe5160120952.1288798116@v2.random>
Message-Id: <20101109151440.BC75.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 19:27:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> This takes advantage of memory compaction to properly generate pages of order >
> 0 if regular page reclaim fails and priority level becomes more severe and we
> don't reach the proper watermarks.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

First, I don't think this patch is related to GFP_ATOMIC. So, I think the 
patch title is a bit misleading.

Second, this patch has two changes. 1) remove PAGE_ALLOC_COSTLY_ORDER 
threshold 2) implement background compaction. please separate them.

Third, This patch makes a lot of PFN order page scan and churn LRU
aggressively. I'm not sure this aggressive lru shuffling is safe and
works effective. I hope you provide some demonstration and/or show 
benchmark result.

Thanks.



