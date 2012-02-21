Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2BUWNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:13:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60859 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab2BUWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:13:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.74.97 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Tue, 21 Feb 2012 14:12:58 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/10] mm/memcg: move lru_lock into lruvec
In-Reply-To: <4F440E1D.7050004@openvz.org>
Message-ID: <alpine.LSU.2.00.1202211406030.2012@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils> <alpine.LSU.2.00.1202201537040.23274@eggly.anvils> <4F434300.3080001@openvz.org> <alpine.LSU.2.00.1202211205280.1858@eggly.anvils> <4F440E1D.7050004@openvz.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012, Konstantin Khlebnikov wrote:
> Hugh Dickins wrote:
> > 
> > I'll have to come back to think about your locking later too;
> > or maybe that's exactly where I need to look, when investigating
> > the mm_inline.h:41 BUG.
> 
> pages_count[] updates looks correct.
> This really may be bug in locking, and this VM_BUG_ON catch it before
> list-debug.

I've still not got into looking at it yet.

You're right to mention DEBUG_LIST: I have that on some of the machines,
and I would expect that to be the first to catch a mislocking issue.

In the past my problems with that BUG (well, the spur to introduce it)
came from hugepages.

> > 
> > But at first sight, I have to say I'm very suspicious: I've never found
> > PageLRU a good enough test for whether we need such a lock, because of
> > races with those pages on percpu lruvec about to be put on the lru.
> > 
> > But maybe once I look closer, I'll find that's handled by your changes
> > away from lruvec; though I'd have thought the same issue exists,
> > independent of whether the pending pages are in vector or list.
> 
> Are you talking about my per-cpu page-lists for lru-adding?

Yes.

> This is just an unnecessary patch, I don't know why I include it into v2 set.
> It does not protect anything.

Okay.

Hugh
