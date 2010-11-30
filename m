Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0K3SfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:35:04 -0500
Received: from smtp-out.google.com ([74.125.121.35]:12955 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0K3SfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:35:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=cZed+wTpou6tid+Ltl1BndtXx+9KECTBQqYj4CNzxYEPtOBRPMoyysjaN+zyEdsYxx
         5f6CsssZmeiij5bpfEaQ==
Date: Tue, 30 Nov 2010 10:34:41 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v3 3/3] Prevent activation of page in madvise_dontneed
In-Reply-To: <a0f2905bb64ce33909d7dd74146bfea826fec21a.1291043274.git.minchan.kim@gmail.com>
Message-ID: <alpine.LSU.2.00.1011301025010.7450@tigran.mtv.corp.google.com>
References: <cover.1291043273.git.minchan.kim@gmail.com> <a0f2905bb64ce33909d7dd74146bfea826fec21a.1291043274.git.minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Minchan Kim wrote:

> Now zap_pte_range alwayas activates pages which are pte_young &&
> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
> it's unnecessary since the page wouldn't use any more.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> 
> Changelog since v2:
>  - remove unnecessary description
> Changelog since v1: 
>  - change word from promote to activate
>  - add activate argument to zap_pte_range and family function
> 
> ---
>  include/linux/mm.h |    4 ++--
>  mm/madvise.c       |    4 ++--
>  mm/memory.c        |   38 +++++++++++++++++++++++---------------
>  mm/mmap.c          |    4 ++--
>  4 files changed, 29 insertions(+), 21 deletions(-)

Everyone else seems pretty happy with this, and I've not checked
at all whether it achieves your purpose; but personally I'd much
prefer a smaller patch which adds your "activate" or "ignore_references"
flag to struct zap_details, instead of passing this exceptional arg
down lots of levels.  That's precisely the purpose of zap_details,
to gather together a few things that aren't needed in the common case
(though I admit the NULL details defaulting may be ugly).

Hugh
