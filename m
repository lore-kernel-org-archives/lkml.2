Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423198Ab2KNSiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:38:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423146Ab2KNSiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:38:08 -0500
Message-ID: <50A3E4F7.5010807@redhat.com>
Date: Wed, 14 Nov 2012 13:37:43 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] sched, numa, mm: Count WS scanning against present
 PTEs, not virtual memory ranges
References: <1352883029-7885-1-git-send-email-mingo@kernel.org> <1352883029-7885-2-git-send-email-mingo@kernel.org>
In-Reply-To: <1352883029-7885-2-git-send-email-mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 03:50 AM, Ingo Molnar wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> By accounting against the present PTEs, scanning speed reflects the
> actual present (mapped) memory.
>
> For this we modify mm/mprotect.c::change_protection() to return the
> number of ptes modified. (No change in functionality.)

We need to figure out what we actually want here.

Do we want to mark 256MB as non-present, or do we want to leave
behind 256MB of non-present (NUMA) memory? :)

-- 
All rights reversed
