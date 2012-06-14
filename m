Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2FNFll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 01:41:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36088 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2FNFlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 01:41:40 -0400
MIME-Version: 1.0
In-Reply-To: <1339645491-5656-1-git-send-email-jiang.liu@huawei.com>
References: <1339645491-5656-1-git-send-email-jiang.liu@huawei.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 01:41:19 -0400
X-Google-Sender-Auth: uyZbcIGIFEm7QVRCSEXEXQ_6NsI
Message-ID: <CAHGf_=r+XnzfBD3EWe9O7iQqSPLwD5ijP5FtBHsc88mTm8mRrA@mail.gmail.com>
Subject: Re: [PATCH] memory hotplug: fix invalid memory access caused by stale
 kswapd pointer
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Keping Chen <chenkeping@huawei.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xishi Qiu <qiuxishi@huawei.com>, Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:44 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
> Function kswapd_stop() will be called to destroy the kswapd work thread
> when all memory of a NUMA node has been offlined. But kswapd_stop() only
> terminates the work thread without resetting NODE_DATA(nid)->kswapd to NULL.
> The stale pointer will prevent kswapd_run() from creating a new work thread
> when adding memory to the memory-less NUMA node again. Eventually the stale
> pointer may cause invalid memory access.
>
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Signed-off-by: Jiang Liu <liuj97@gmail.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
