Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2LTWoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:44:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26304 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2LTWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:44:29 -0500
Message-ID: <50D3947F.2060503@oracle.com>
Date: Thu, 20 Dec 2012 17:43:11 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Petr Holasek <pholasek@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] ksm: make rmap walks more scalable
References: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils> <alpine.LNX.2.00.1212191742440.25409@eggly.anvils> <50D387FD.4020008@oracle.com> <alpine.LNX.2.00.1212201409170.977@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1212201409170.977@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 05:37 PM, Hugh Dickins wrote:
> On Thu, 20 Dec 2012, Sasha Levin wrote:
>> On 12/19/2012 08:44 PM, Hugh Dickins wrote:
>>> The rmap walks in ksm.c are like those in rmap.c:
>>> they can safely be done with anon_vma_lock_read().
>>>
>>> Signed-off-by: Hugh Dickins <hughd@google.com>
>>> ---
>>
>> Hi Hugh,
>>
>> This patch didn't fix the ksm oopses I'm seeing.
> 
> I wouldn't expect it to (and should certainly have mentioned oopses
> in the commit message if I'd intended): this patch was merely an
> optimization/clarification of a commit gone in for 3.8-rc1.
> 
> Understandable misunderstanding: you took my Cc too seriously,
> I just thought I'd better keep Petr in the loop on current changes
> to ksm.c, and foolishly kept you in too ;)
> 
> Your oopses are on linux-next, which as of 20121220 still had Petr's
> nice but buggy NUMA KSM patch in: it should go away when Stephen gets
> a fresh mm update from Andrew, then reappear once his v6 goes into mm.
> 
> To stop these oopses in get_mergeable_page (inlined in
> unstable_tree_search_insert) you need the patch I showed on
> Tuesday, which I hope he'll merge in for his v6.  That doesn't fix
> all of the problems, but hopefully all that you'll encounter before
> I've devised a fix for the separate stale stable_nodes issue.

My bad! I thought that this is the finalized version of the patch from
Tuesday and was surprised when the oops was still there :)

fwiw I'll use this to report that I'm not seeing any unexpected behaviour
with this patch applied.


Thanks,
Sasha

