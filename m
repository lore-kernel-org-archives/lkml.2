Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2HGOpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:45:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab2HGOpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:45:35 -0400
Message-ID: <50212A05.2070503@redhat.com>
Date: Tue, 07 Aug 2012 10:45:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan@kernel.org>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mm: have order > 0 compaction start near a pageblock
 with free pages
References: <1344342677-5845-1-git-send-email-mgorman@suse.de> <1344342677-5845-7-git-send-email-mgorman@suse.de>
In-Reply-To: <1344342677-5845-7-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 08:31 AM, Mel Gorman wrote:
> commit [7db8889a: mm: have order>  0 compaction start off where it left]
> introduced a caching mechanism to reduce the amount work the free page
> scanner does in compaction. However, it has a problem. Consider two process
> simultaneously scanning free pages
>
> 				    			C
> Process A		M     S     			F
> 		|---------------------------------------|
> Process B		M 	FS

Argh. Good spotting.

> This is not optimal and it can still race but the compact_cached_free_pfn
> will be pointing to or very near a pageblock with free pages.

Agreed on the "not optimal", but I also cannot think of a better
idea right now. Getting this fixed for 3.6 is important, we can
think of future optimizations in San Diego.

> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
