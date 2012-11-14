Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab2KNSBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:01:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847Ab2KNSBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:01:38 -0500
Message-ID: <50A3DC54.8010206@redhat.com>
Date: Wed, 14 Nov 2012 13:00:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/31] mm: numa: Avoid double faulting after migrating
 misplaced page
References: <1352805180-1607-1-git-send-email-mgorman@suse.de> <1352805180-1607-18-git-send-email-mgorman@suse.de>
In-Reply-To: <1352805180-1607-18-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 06:12 AM, Mel Gorman wrote:
> The pte_same check after a misplaced page is successfully migrated will
> never succeed and force a double fault to fix it up as pointed out by Rik
> van Riel. This was the "safe" option but it's expensive.
>
> This patch uses the migration allocation callback to record the location
> of the newly migrated page. If the page is the same when the PTE lock is
> reacquired it is assumed that it is safe to complete the pte_numa fault
> without incurring a double fault.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
