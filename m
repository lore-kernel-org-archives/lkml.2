Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab0ECQzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab0ECQzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:55:06 -0400
Message-ID: <4BDEFF9E.6080508@redhat.com>
Date: Mon, 03 May 2010 12:53:50 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
References: <20100503121743.653e5ecc@annuminas.surriel.com> <20100503121847.7997d280@annuminas.surriel.com> <alpine.LFD.2.00.1005030940490.5478@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005030940490.5478@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 12:41 PM, Linus Torvalds wrote:
> On Mon, 3 May 2010, Rik van Riel wrote:
>>
>> Both the page migration code and the transparent hugepage patches expect
>> 100% reliable rmap lookups and use page_lock_anon_vma(page) to prevent
>> races with mmap, munmap, expand_stack, etc.
>
> Pretty much same comments as for the other one. Why are we pandering to
> the case that is/should be unusual?

In this case, because the fix from the migration side is
difficult and fragile, while fixing things from the mmap
side is straightforward.

I believe the overhead of patch 1/2 should be minimal
as well, because the locks we take are the _depth_ of
the process tree (truncated every exec), not the width.


As for patch 2/2, Mel has an alternative approach for that:

http://lkml.org/lkml/2010/4/30/198

Does Mel's patch seem more reasonable to you?

-- 
All rights reversed
