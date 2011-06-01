Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1FAP4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab1FAP4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:56:03 -0400
Message-ID: <4DE66107.10908@redhat.com>
Date: Wed, 01 Jun 2011 11:55:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 04/10] Add additional isolation mode
References: <cover.1306689214.git.minchan.kim@gmail.com> <5b0f0be7ee441ea27ffcad81d2637ac09407acf3.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <5b0f0be7ee441ea27ffcad81d2637ac09407acf3.1306689214.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2011 02:13 PM, Minchan Kim wrote:
> There are some places to isolate lru page and I believe
> users of isolate_lru_page will be growing.
> The purpose of them is each different so part of isolated pages
> should put back to LRU, again.
>
> The problem is when we put back the page into LRU,
> we lose LRU ordering and the page is inserted at head of LRU list.
> It makes unnecessary LRU churning so that vm can evict working set pages
> rather than idle pages.
>
> This patch adds new modes when we isolate page in LRU so we don't isolate pages
> if we can't handle it. It could reduce LRU churning.
>
> This patch doesn't change old behavior. It's just used by next patches.
>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman<mgorman@suse.de>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>
