Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0EMCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:25:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0EMCZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:25:57 -0400
Message-ID: <4BEB630B.8070805@redhat.com>
Date: Wed, 12 May 2010 22:25:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/5] track the root (oldest) anon_vma
References: <20100512133815.0d048a86@annuminas.surriel.com>	<20100512133958.3aff0515@annuminas.surriel.com> <20100513093828.1cd022db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100513093828.1cd022db.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 08:38 PM, KAMEZAWA Hiroyuki wrote:
> On Wed, 12 May 2010 13:39:58 -0400
> Rik van Riel<riel@redhat.com>  wrote:
>
>> Subject: track the root (oldest) anon_vma
>>
>> Track the root (oldest) anon_vma in each anon_vma tree.   Because we only
>> take the lock on the root anon_vma, we cannot use the lock on higher-up
>> anon_vmas to lock anything.  This makes it impossible to do an indirect
>> lookup of the root anon_vma, since the data structures could go away from
>> under us.
>>
>> However, a direct pointer is safe because the root anon_vma is always the
>> last one that gets freed on munmap or exit, by virtue of the same_vma list
>> order and unlink_anon_vmas walking the list forward.
>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>
>
> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> I welcome this. Thank you!
>
> Reading 4/5, I felt I'm grad if you add a Documentation or very-precise-comment
> about the new anon_vma rules and the _meaning_ of anon_vma_root_lock.
> I cannot fully convice myself that I understand them all.

Please send me a list of all the questions that come up
when you read the patches, and I'll prepare a patch 6/5
with just documentation :)

-- 
All rights reversed
