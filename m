Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1FYVm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:42:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab1FYVm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:42:26 -0400
Message-ID: <4E065630.2070407@redhat.com>
Date: Sat, 25 Jun 2011 17:42:08 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?UMOhZHJhaWcgQnJh?= =?UTF-8?B?ZHk=?= <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] mm: vmscan: Evaluate the watermarks against the correct
 classzone
References: <1308926697-22475-1-git-send-email-mgorman@suse.de> <1308926697-22475-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1308926697-22475-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 10:44 AM, Mel Gorman wrote:
> When deciding if kswapd is sleeping prematurely, the classzone is
> taken into account but this is different to what balance_pgdat() and
> the allocator are doing. Specifically, the DMA zone will be checked
> based on the classzone used when waking kswapd which could be for a
> GFP_KERNEL or GFP_HIGHMEM request. The lowmem reserve limit kicks in,
> the watermark is not met and kswapd thinks its sleeping prematurely
> keeping kswapd awake in error.
>
> Reported-and-tested-by: Pádraig Brady<P@draigBrady.com>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
