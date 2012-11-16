Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2KPA3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:29:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2KPA3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:29:22 -0500
Date: Thu, 15 Nov 2012 16:29:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Lin feng <linfeng@cn.fujitsu.com>
Subject: Re: [PART3 Patch v2 13/14] page_alloc: use N_MEMORY instead
 N_HIGH_MEMORY change the node_states initialization
Message-Id: <20121115162920.af46d08a.akpm@linux-foundation.org>
In-Reply-To: <1352969857-26623-14-git-send-email-wency@cn.fujitsu.com>
References: <1352969857-26623-1-git-send-email-wency@cn.fujitsu.com>
	<1352969857-26623-14-git-send-email-wency@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012 16:57:36 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> N_HIGH_MEMORY stands for the nodes that has normal or high memory.
> N_MEMORY stands for the nodes that has any memory.
> 
> The code here need to handle with the nodes which have memory, we should
> use N_MEMORY instead.
> 
> Since we introduced N_MEMORY, we update the initialization of node_states.

reset_zone_present_pages() has been removed by the recently-queued
revert-mm-fix-up-zone-present-pages.patch, so I dropped that hunk.

We still have

akpm:/usr/src/25> grep N_HIGH_MEMORY mm/page_alloc.c
        [N_HIGH_MEMORY] = { { [0] = 1UL } },
                        node_set_state(nid, N_HIGH_MEMORY);
                        if (N_NORMAL_MEMORY != N_HIGH_MEMORY &&

which I hope is correct.  Can you please check it?
