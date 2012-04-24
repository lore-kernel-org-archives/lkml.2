Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab2DXFep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 01:34:45 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53764 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2DXFeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 01:34:44 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-e0-4f963b724b0f
Message-ID: <4F963B8E.9030105@kernel.org>
Date: Tue, 24 Apr 2012 14:35:10 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] propagate gfp_t to page table alloc functions
References: <1335171318-4838-1-git-send-email-minchan@kernel.org> <4F963742.2030607@jp.fujitsu.com>
In-Reply-To: <4F963742.2030607@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 02:16 PM, KAMEZAWA Hiroyuki wrote:

> (2012/04/23 17:55), Minchan Kim wrote:
> 
>> As I test some code, I found a problem about deadlock by lockdep.
>> The reason I saw the message is __vmalloc calls map_vm_area which calls
>> pud/pmd_alloc without gfp_t. so although we call __vmalloc with
>> GFP_ATOMIC or GFP_NOIO, it ends up allocating pages with GFP_KERNEL.
>> The should be a BUG. This patch fixes it by passing gfp_to to low page
>> table allocate functions.
>>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> 
> Hmm ? vmalloc should support GFP_ATOMIC ?


I'm not sure but alloc_large_system_hash already has used.
And it's not specific on GFP_ATOMIC.
We have to care of GFP_NOFS and GFP_NOIO to prevent deadlock on reclaim
context.
There are some places to use GFP_NOFS and we don't emit any warning
message in case of that.

> 
> And, do we need to change all pud_,pgd_,pmd_,pte_alloc() for users pgtables ?


Maybe.


-- 
Kind regards,
Minchan Kim
