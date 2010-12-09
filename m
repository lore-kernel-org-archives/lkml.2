Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0LIWO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:14:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452Ab0LIWOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:14:25 -0500
Date: Thu, 9 Dec 2010 14:13:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] vmscan: make kswapd use a correct order
Message-Id: <20101209141317.60d14fb5.akpm@linux-foundation.org>
In-Reply-To: <1291305649-2405-1-git-send-email-minchan.kim@gmail.com>
References: <1291305649-2405-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Dec 2010 01:00:49 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> +static bool kswapd_try_to_sleep(pg_data_t *pgdat, int order)

OT: kswapd_try_to_sleep() does a
trace_mm_vmscan_kswapd_sleep(pgdat->node_id) if it sleeps for a long
time, but doesn't trace anything at all if it does a short sleep. 
Where's the sense in that?
