Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab2FOO23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:28:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985Ab2FOO22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:28:28 -0400
Date: Fri, 15 Jun 2012 15:28:20 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Keping Chen <chenkeping@huawei.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xishi Qiu <qiuxishi@huawei.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] memory hotplug: fix invalid memory access caused by
 stale kswapd pointer
Message-ID: <20120615142820.GC20467@suse.de>
References: <1339645491-5656-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1339645491-5656-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 11:44:51AM +0800, Jiang Liu wrote:
> Function kswapd_stop() will be called to destroy the kswapd work thread
> when all memory of a NUMA node has been offlined. But kswapd_stop() only
> terminates the work thread without resetting NODE_DATA(nid)->kswapd to NULL.
> The stale pointer will prevent kswapd_run() from creating a new work thread
> when adding memory to the memory-less NUMA node again. Eventually the stale
> pointer may cause invalid memory access.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> 

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
