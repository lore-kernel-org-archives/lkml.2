Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0EGFxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:53:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32929 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0EGFxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:53:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 7 May 2010 14:49:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
Message-Id: <20100507144937.2266df7d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100507085219.5821f721.kamezawa.hiroyu@jp.fujitsu.com>
References: <1273065281-13334-1-git-send-email-mel@csn.ul.ie>
	<1273065281-13334-2-git-send-email-mel@csn.ul.ie>
	<20100506163837.bf6587ef.kamezawa.hiroyu@jp.fujitsu.com>
	<20100506094621.GZ20979@csn.ul.ie>
	<20100507085219.5821f721.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 08:52:19 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 6 May 2010 10:46:21 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:

> > 5. It added a field to mm_struct. It's the smallest of concerns though.
> > 
> > Do you think it's a better approach and should be revisited?
> > 
> > 
> 
> If everyone think seqlock is simple, I think it should be. But it seems you all are
> going ahead with anon_vma->lock approach. 
> (Basically, it's ok to me if it works. We may be able to make it better in later.)
> 
> I'll check your V7.
> 
> Thank you for answering.

plz forget about seq_counter. we may have to add "retry" path for avoiding
dead lock. If so, using anon_vma->lock in proper manner seems sane.

Thanks,
-Kame

