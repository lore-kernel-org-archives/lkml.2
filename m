Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2FTJGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:06:32 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41526 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab2FTJGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:06:30 -0400
Message-ID: <4FE1915B.3040303@huawei.com>
Date: Wed, 20 Jun 2012 17:01:15 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Minchan Kim <minchan@kernel.org>, Keping Chen <chenkeping@huawei.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tony Luck <tony.luck@intel.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] trivial, memory hotplug: add kswapd_is_running() for
 better readability
References: <4FD97718.6060008@kernel.org> <1339663776-196-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1206161913370.797@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206161913370.797@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This isn't better, there's no functional change and you've just added a 
> second conditional for no reason and an unnecessary kswapd_is_running() 
> function.
> 
> More concerning is that online_pages() doesn't check the return value of 
> kswapd_run().  We should probably fail the memory hotplug operation that 
> onlines a new node and doesn't have a kswapd running and cleanup after 
> ourselves in online_pages() with some sane error handling.

Hi David,
	Good points! Is it feasible to use schedule_delayed_work_on() to
retry kswapd_run() instead of ralling back the online operation in case
kswapd_run() failed to create the work thread?
	Thank!
	Gerry


