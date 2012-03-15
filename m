Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031556Ab2COBsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:48:30 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33479 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760411Ab2COBs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:48:28 -0400
Date: Wed, 14 Mar 2012 18:47:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7 v2] mm: rework __isolate_lru_page() file/anon
 filter
In-Reply-To: <4F5B22DE.4020402@openvz.org>
Message-ID: <alpine.LSU.2.00.1203141842490.2232@eggly.anvils>
References: <20120229091547.29236.28230.stgit@zurg> <20120303091327.17599.80336.stgit@zurg> <alpine.LSU.2.00.1203061904570.18675@eggly.anvils> <20120308143034.f3521b1e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LSU.2.00.1203081758490.18195@eggly.anvils>
 <4F59AE3C.5040200@openvz.org> <alpine.LSU.2.00.1203091559260.23317@eggly.anvils> <4F5AFAF0.6060608@openvz.org> <4F5B22DE.4020402@openvz.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2012, Konstantin Khlebnikov wrote:
> Konstantin Khlebnikov wrote:
> > 
> > No, for non-lumpy isolation we don't need this check at all,
> > because all pages already picked from right lru list.
> > 
> > I'll send separate patch for this (on top v5 patchset), after meditation =)
> 
> Heh, looks like we don't need these checks at all:
> without RECLAIM_MODE_LUMPYRECLAIM we isolate only pages from right lru,
> with RECLAIM_MODE_LUMPYRECLAIM we isolate pages from all evictable lru.
> Thus we should check only PageUnevictable() on lumpy reclaim.

Yes, those were great simplfying insights: I'm puzzling over why you
didn't follow through on them in your otherwise nice 4.5/7, which
still involves lru bits in the isolate mode?

Hugh
