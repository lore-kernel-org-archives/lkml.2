Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0K2E20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 23:28:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab0K2E2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 23:28:25 -0500
Message-ID: <4CF32BD5.8050006@redhat.com>
Date: Sun, 28 Nov 2010 23:28:05 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 3/3] Prevent promotion of page in madvise_dontneed
References: <7b50614882592047dfd96f6ca2bb2d0baa8f5367.1290956059.git.minchan.kim@gmail.com> <48315b5fe54efa08982aa7df77e8abe793889e3a.1290956059.git.minchan.kim@gmail.com>
In-Reply-To: <48315b5fe54efa08982aa7df77e8abe793889e3a.1290956059.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2010 10:02 AM, Minchan Kim wrote:
> Now zap_pte_range alwayas promotes pages which are pte_young&&
> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
> it's unnecessary since the page wouldn't use any more.
>
> If the page is sharred by other processes and it's real working set

This line seems to be superfluous, I don't see any special
treatment for this case in the code.

> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: Nick Piggin<npiggin@kernel.dk>
> Cc: Mel Gorman<mel@csn.ul.ie>
> Cc: Wu Fengguang<fengguang.wu@intel.com>

The patch itself looks good to me.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
