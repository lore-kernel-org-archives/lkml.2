Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2EAVGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 17:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab2EAVGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 17:06:37 -0400
Message-ID: <4FA0504D.60802@redhat.com>
Date: Tue, 01 May 2012 17:06:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] mm: readahead: move radix tree hole searching here
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org> <1335861713-4573-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1335861713-4573-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 04:41 AM, Johannes Weiner wrote:
> The readahead code searches the page cache for non-present pages, or
> holes, to get a picture of the area surrounding a fault e.g.
>
> For this it sufficed to rely on the radix tree definition of holes,
> which is "empty tree slot".  This is about to change, though, because
> shadow page descriptors will be stored in the page cache when the real
> pages get evicted from memory.
>
> Fortunately, nobody outside the readahead code uses these functions
> and they have no internal knowledge of the radix tree structures, so
> just move them over to mm/readahead.c where they can later be adapted
> to handle the new definition of "page cache hole".
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
