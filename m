Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab1FVXFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 19:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685Ab1FVXFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 19:05:20 -0400
Message-ID: <4E0274FC.5070505@redhat.com>
Date: Wed, 22 Jun 2011 19:04:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Righi <andrea@betterlinux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Marcus Sorensen <marcus@bluehost.com>, Matt Heaton <matt@bluehost.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] fadvise: move active pages to inactive list with
 POSIX_FADV_DONTNEED
References: <1308779480-4950-1-git-send-email-andrea@betterlinux.com>
In-Reply-To: <1308779480-4950-1-git-send-email-andrea@betterlinux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 05:51 PM, Andrea Righi wrote:
> There were some reported problems in the past about trashing page cache
> when a backup software (i.e., rsync) touches a huge amount of pages (see
> for example [1]).
>
> This problem has been almost fixed by the Minchan Kim's patch [2] and a
> proper use of fadvise() in the backup software. For example this patch
> set [3] has been proposed for inclusion in rsync.
>
> However, there can be still other similar trashing problems: when the
> backup software reads all the source files, some of them may be part of
> the actual working set of the system. When a
> posix_fadvise(POSIX_FADV_DONTNEED) is performed _all_ pages are evicted
> from pagecache, both the working set and the use-once pages touched only
> by the backup software.
>
> With the following solution when posix_fadvise(POSIX_FADV_DONTNEED) is
> called for an active page instead of removing it from the page cache it
> is added to the tail of the inactive list. Otherwise, if it's already in
> the inactive list the page is removed from the page cache.

> Signed-off-by: Andrea Righi<andrea@betterlinux.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
