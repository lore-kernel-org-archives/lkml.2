Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab2KOV1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:27:09 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37904 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2KOV1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:27:08 -0500
Date: Thu, 15 Nov 2012 13:27:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] mm: fix a regression with HIGHMEM introduced by changeset
 7f1290f2f2a4d
In-Reply-To: <20121115112454.e582a033.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1211151326500.27188@chino.kir.corp.google.com>
References: <1352165517-9732-1-git-send-email-jiang.liu@huawei.com> <20121106124315.79deb2bc.akpm@linux-foundation.org> <50A3B013.4030207@gmail.com> <20121115112454.e582a033.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Andrew Morton wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: revert "mm: fix-up zone present pages"
> 
> Revert
> 
> commit 7f1290f2f2a4d2c3f1b7ce8e87256e052ca23125
> Author:     Jianguo Wu <wujianguo@huawei.com>
> AuthorDate: Mon Oct 8 16:33:06 2012 -0700
> Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Tue Oct 9 16:22:54 2012 +0900
> 
>     mm: fix-up zone present pages
> 
> 
> That patch tried to fix a issue when calculating zone->present_pages, but
> it caused a regression on 32bit systems with HIGHMEM.  With that
> changeset, reset_zone_present_pages() resets all zone->present_pages to
> zero, and fixup_zone_present_pages() is called to recalculate
> zone->present_pages when the boot allocator frees core memory pages into
> buddy allocator.  Because highmem pages are not freed by bootmem
> allocator, all highmem zones' present_pages becomes zero.
> 
> Various options for improving the situation are being discussed but for
> now, let's return to the 3.6 code.
> 
> Cc: Jianguo Wu <wujianguo@huawei.com>
> Cc: Jiang Liu <jiang.liu@huawei.com>
> Cc: Petr Tesarik <ptesarik@suse.cz>
> Cc: "Luck, Tony" <tony.luck@intel.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>
