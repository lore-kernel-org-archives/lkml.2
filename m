Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2COGD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:03:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53498 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2COGDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:03:54 -0400
Message-ID: <4F618645.8020507@openvz.org>
Date: Thu, 15 Mar 2012 10:03:49 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7 v2] mm: rework __isolate_lru_page() file/anon filter
References: <20120229091547.29236.28230.stgit@zurg> <20120303091327.17599.80336.stgit@zurg> <alpine.LSU.2.00.1203061904570.18675@eggly.anvils> <20120308143034.f3521b1e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LSU.2.00.1203081758490.18195@eggly.anvils> <4F59AE3C.5040200@openvz.org> <alpine.LSU.2.00.1203091559260.23317@eggly.anvils> <4F5AFAF0.6060608@openvz.org> <4F5B22DE.4020402@openvz.org> <alpine.LSU.2.00.1203141842490.2232@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1203141842490.2232@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sat, 10 Mar 2012, Konstantin Khlebnikov wrote:
>> Konstantin Khlebnikov wrote:
>>>
>>> No, for non-lumpy isolation we don't need this check at all,
>>> because all pages already picked from right lru list.
>>>
>>> I'll send separate patch for this (on top v5 patchset), after meditation =)
>>
>> Heh, looks like we don't need these checks at all:
>> without RECLAIM_MODE_LUMPYRECLAIM we isolate only pages from right lru,
>> with RECLAIM_MODE_LUMPYRECLAIM we isolate pages from all evictable lru.
>> Thus we should check only PageUnevictable() on lumpy reclaim.
>
> Yes, those were great simplfying insights: I'm puzzling over why you
> didn't follow through on them in your otherwise nice 4.5/7, which
> still involves lru bits in the isolate mode?

Actually filter is required for single case: lumpy isolation for shrink_active_list().
Maybe I'm wrong, or this is bug, but I don't see any reasons why this can not happen:
sc->reclaim_mode manipulations are very tricky.

>
> Hugh
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>

