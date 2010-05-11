Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0EKRWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab0EKRWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:22:30 -0400
Message-ID: <4BE9920C.3020901@redhat.com>
Date: Tue, 11 May 2010 13:21:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and
 rmap_walk() during migration by not migrating temporary stacks
References: <20100511085752.GM26611@csn.ul.ie> <alpine.LFD.2.00.1005111009500.3711@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005111009500.3711@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 01:11 PM, Linus Torvalds wrote:
> On Tue, 11 May 2010, Mel Gorman wrote:
>>
>> This patch closes the most important race in relation to exec and
>> migration. With it applied, the swapops bug is no longer triggering for
>> known problem workloads. If you pick it up, it should go with the other
>> mmmigration-* fixes in mm.
>
> Ack. _Much_ better and clearer.
>
> I'm not entirely sure we need that "maybe_stack" (if we need it, that
> would sound like a problem anyway), but I guess it can't hurt either.

Just a heads up - I am looking at creating a patch now that
allows us to _always_ lock the root anon_vma lock, when locking
the anon_vma.

That should take care of the other issue pretty cleanly, while
still allowing us to only walk the VMAs we have to walk in
places like rmap_walk.

-- 
All rights reversed
