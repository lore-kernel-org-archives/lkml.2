Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab0HEPGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933539Ab0HEPGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:06:34 -0400
Message-ID: <4C5AD348.3050404@redhat.com>
Date: Thu, 05 Aug 2010 11:05:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/7] vmscan: synchronous lumpy reclaim don't call congestion_wait()
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com> <20100805151229.31BD.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100805151229.31BD.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 02:13 AM, KOSAKI Motohiro wrote:
> congestion_wait() mean "waiting quueue congestion is cleared".
> That said, if the system have plenty dirty pages and flusher thread push
> new request to IO queue conteniously, IO queue are not cleared
> congestion status for long time. thus, congestion_wait(HZ/10) become
> almostly equivalent schedule_timeout(HZ/10).
>
> However, synchronous lumpy reclaim donesn't need this
> congestion_wait() at all. shrink_page_list(PAGEOUT_IO_SYNC) are
> using wait_on_page_writeback() and it provide sufficient waiting.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
