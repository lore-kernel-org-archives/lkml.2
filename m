Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab2CBIFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:05:06 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58667 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2CBIFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:05:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Mar 2012 17:03:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] mm: rework reclaim_stat counters
Message-Id: <20120302170328.37f42337.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4F506486.4090204@openvz.org>
References: <20120229090748.29236.35489.stgit@zurg>
	<20120229091556.29236.96896.stgit@zurg>
	<20120302142825.cd583b59.kamezawa.hiroyu@jp.fujitsu.com>
	<4F506486.4090204@openvz.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2012 10:11:18 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 29 Feb 2012 13:15:56 +0400
> > Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
> >
> >> Currently there is two types of reclaim-stat counters:
> >> recent_scanned (pages picked from from lru),
> >> recent_rotated (pages putted back to active lru).
> >> Reclaimer uses ratio recent_rotated / recent_scanned
> >> for balancing pressure between file and anon pages.
> >>
> >> But if we pick page from lru we can either reclaim it or put it back to lru, thus:
> >> recent_scanned == recent_rotated[inactive] + recent_rotated[active] + reclaimed
> >> This can be called "The Law of Conservation of Memory" =)
> >>
> > I'm sorry....where is the count for active->incative ?
> 
> If reclaimer deactivates page it will bump recent_rotated[LRU_INACTIVE_ANON/FILE],
> (if I understand your question right) recent_rotated[] now count each evictable lru independently
> 

Hm, then

	active -> active   : recent_rotated[active]   += 1 
	active -> inactive : recent_rotated[inacitve] += 1
	inactive->inactive : recent_rotated[inactive] += 1
	inactive->active   : recent_rotated[active]   += 1 ?

Ok, it seems rotated[active] + rotated[inactive] == scan.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

