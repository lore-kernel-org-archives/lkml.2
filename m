Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0K2EZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 23:25:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab0K2EZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 23:25:55 -0500
Message-ID: <4CF32B24.50509@redhat.com>
Date: Sun, 28 Nov 2010 23:25:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v2 2/3] move ClearPageReclaim
References: <7b50614882592047dfd96f6ca2bb2d0baa8f5367.1290956059.git.minchan.kim@gmail.com> <c3b1c78f0e2eba5dfebda7c363c4274e649ab36a.1290956059.git.minchan.kim@gmail.com>
In-Reply-To: <c3b1c78f0e2eba5dfebda7c363c4274e649ab36a.1290956059.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2010 10:02 AM, Minchan Kim wrote:
> fe3cba17 added ClearPageReclaim into clear_page_dirty_for_io for
> preventing fast reclaiming readahead marker page.
>
> In this series, PG_reclaim is used by invalidated page, too.
> If VM find the page is invalidated and it's dirty, it sets PG_reclaim
> to reclaim asap. Then, when the dirty page will be writeback,
> clear_page_dirty_for_io will clear PG_reclaim unconditionally.
> It disturbs this serie's goal.
>
> I think it's okay to clear PG_readahead when the page is dirty, not
> writeback time. So this patch moves ClearPageReadahead.
> This patch needs Wu's opinion.

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
