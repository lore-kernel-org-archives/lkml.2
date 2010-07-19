Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966423Ab0GSTA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965169Ab0GSTAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:00:55 -0400
Message-ID: <4C44A098.1010806@redhat.com>
Date: Mon, 19 Jul 2010 14:59:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 8/8] vmscan: Kick flusher threads to clean pages when
 reclaim is encountering dirty pages
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie> <1279545090-19169-9-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1279545090-19169-9-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 09:11 AM, Mel Gorman wrote:
> There are a number of cases where pages get cleaned but two of concern
> to this patch are;
>    o When dirtying pages, processes may be throttled to clean pages if
>      dirty_ratio is not met.
>    o Pages belonging to inodes dirtied longer than
>      dirty_writeback_centisecs get cleaned.
>
> The problem for reclaim is that dirty pages can reach the end of the LRU
> if pages are being dirtied slowly so that neither the throttling cleans
> them or a flusher thread waking periodically.

I can't see a better way to do this without creating
a way-too-big-to-merge patch series, and this patch
should result in the right behaviour, so ...

Acked-by: Rik van Riel <riel@redhat.com>

