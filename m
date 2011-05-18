Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1ERGJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 02:09:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48828 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1ERGJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 02:09:31 -0400
Message-ID: <4DD36299.8000108@cs.helsinki.fi>
Date: Wed, 18 May 2011 09:09:29 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: slub: Do not wake kswapd for SLUBs speculative
 high-order allocations
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-3-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105161410090.4353@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105161410090.4353@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/11 12:10 AM, David Rientjes wrote:
> On Fri, 13 May 2011, Mel Gorman wrote:
>
>> To avoid locking and per-cpu overhead, SLUB optimisically uses
>> high-order allocations and falls back to lower allocations if they
>> fail.  However, by simply trying to allocate, kswapd is woken up to
>> start reclaiming at that order. On a desktop system, two users report
>> that the system is getting locked up with kswapd using large amounts
>> of CPU.  Using SLAB instead of SLUB made this problem go away.
>>
>> This patch prevents kswapd being woken up for high-order allocations.
>> Testing indicated that with this patch applied, the system was much
>> harder to hang and even when it did, it eventually recovered.
>>
>> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Acked-by: David Rientjes<rientjes@google.com>

Christoph? I think this patch is sane although the original rationale 
was to workaround kswapd problems.

                 Pekka
