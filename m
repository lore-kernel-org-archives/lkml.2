Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab2HUHhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:37:22 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53381 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2HUHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:37:19 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-98-50333aad8e5b
Date: Tue, 21 Aug 2012 16:37:38 +0900
From: Minchan Kim <minchan@kernel.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hughd@google.com,
        linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory hotplug: reset pgdat->kswapd to NULL if creating
 kernel thread fails
Message-ID: <20120821073738.GA24667@bbox>
References: <50332B37.2000500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50332B37.2000500@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 02:31:19PM +0800, Wen Congyang wrote:
> If kthread_run() fails, pgdat->kswapd contains errno. When we stop
> this thread, we only check whether pgdat->kswapd is NULL and access
> it. If it contains errno, it will cause page fault. Reset pgdat->kswapd
> to NULL when creating kernel thread fails can avoid this problem.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

Nitpick: Why doesn't online_pages check kswapd_run's return value?
         I hope memory-hotplug can handle this error rightly without
         relying on this patch in the future.

-- 
Kind regards,
Minchan Kim
