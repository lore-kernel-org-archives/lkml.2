Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab1KGCfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 21:35:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39564 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab1KGCfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 21:35:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Nov 2011 11:34:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [rfc 2/3] mm: vmscan: treat inactive cycling as neutral
Message-Id: <20111107113417.1b7581a5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111102163213.GI19965@redhat.com>
References: <20110808110658.31053.55013.stgit@localhost6>
	<CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com>
	<4E3FD403.6000400@parallels.com>
	<20111102163056.GG19965@redhat.com>
	<20111102163213.GI19965@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011 17:32:13 +0100
Johannes Weiner <jweiner@redhat.com> wrote:

> Each page that is scanned but put back to the inactive list is counted
> as a successful reclaim, which tips the balance between file and anon
> lists more towards the cycling list.
> 
> This does - in my opinion - not make too much sense, but at the same
> time it was not much of a problem, as the conditions that lead to an
> inactive list cycle were mostly temporary - locked page, concurrent
> page table changes, backing device congested - or at least limited to
> a single reclaimer that was not allowed to unmap or meddle with IO.
> More important than being moderately rare, those conditions should
> apply to both anon and mapped file pages equally and balance out in
> the end.
> 
> Recently, we started cycling file pages in particular on the inactive
> list much more aggressively, for used-once detection of mapped pages,
> and when avoiding writeback from direct reclaim.
> 
> Those rotated pages do not exactly speak for the reclaimability of the
> list they sit on and we risk putting immense pressure on file list for
> no good reason.
> 
> Instead, count each page not reclaimed and put back to any list,
> active or inactive, as rotated, so they are neutral with respect to
> the scan/rotate ratio of the list class, as they should be.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

I think this makes sense.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I wonder it may be better to have victim list for written-backed pages..

