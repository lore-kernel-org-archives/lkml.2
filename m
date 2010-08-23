Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0HWM4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:56:46 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:38435 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751273Ab0HWM4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:56:44 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: sWhyx08VM1kZMX2nOeZiEcM9rsB0f7Xg3HZKJRkaYLIsptt
 sDeJZIDbVb2U5FOFAIiE6XqHu14cMneUjDIlWjXzz8ggEBX6K0NYuVirPiSB
 4xgxCv0EoXIvMpPj98inPdI81fTWHD_L_wDb5w.eVfxYyzP5_Y6Go2BH0ddS
 0j8My1t18_CAz.Og8r.Yua1LH_kjkKBctiRIeAeIYZMNI6aNP3NCqHQ7bkp4
 m
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 07:56:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <1282550442-15193-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008230750380.4094@router.home>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <1282550442-15193-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Mel Gorman wrote:

> This patch introduces zone_nr_free_pages() to take a slightly more accurate
> estimate of NR_FREE_PAGES while kswapd is awake. The estimate is not perfect
> and may result in cache line bounces but is expected to be lighter than the
> IPI calls necessary to continually drain the per-cpu counters while kswapd
> is awake.

The delta of the counters could also be reduced to increase accuracy.
See refresh_zone_stat_thresholds().

Also would it be possible to add the summation function to vmstat? It may
be useful elsewhere.

A new function like

	zone_page_state_snapshot()

or so?


