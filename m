Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0KRTRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:17:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0KRTRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:17:39 -0500
Date: Thu, 18 Nov 2010 20:15:40 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH 64 of 66] scale nr_rotated to balance memory pressure
Message-ID: <20101118191540.GG30376@random.random>
References: <patchbomb.1288798055@v2.random>
 <54b5b2d012ff38e341ad.1288798119@v2.random>
 <20101109151605.BC78.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109151605.BC78.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 03:16:21PM +0900, KOSAKI Motohiro wrote:
> I haven't seen this patch series carefully yet. So, probably
> my question is dumb. Why don't we need to change ->recent_scanned[] too?

That one is taken care by the prev patch where it is increased by 512
through nr_taken (after the previous patch the isolation methods now
return in 4k units). What was left to update was the nr_rotated++
which is why this patch isn't touching the recent_scanned.

Andrea
