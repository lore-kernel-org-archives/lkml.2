Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2I1Ajc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:39:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54093 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2I1Aja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:39:30 -0400
Message-ID: <5064F1BB.8050204@gmail.com>
Date: Fri, 28 Sep 2012 08:39:23 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Jianguo Wu <wujianguo@huawei.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Xishi Qiu <qiuxishi@huawei.com>,
        Mel Gorman <mgorman@suse.de>, linux-doc@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/3] memory_hotplug: fix memory hotplug bug
References: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 02:47 PM, Lai Jiangshan wrote:
> We found 3 bug while we test and develop memory hotplug.
>
> PATCH1~2: the old code does not handle node_states[N_NORMAL_MEMORY] correctly,
> it corrupts the memory.
>
> PATCH3: move the modification of zone_start_pfn into corresponding lock.

please fully test them before send out. thanks.

>
> CC: Rob Landley <rob@landley.net>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Jiang Liu <jiang.liu@huawei.com>
> CC: Jianguo Wu <wujianguo@huawei.com>
> CC: Kay Sievers <kay.sievers@vrfy.org>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Xishi Qiu <qiuxishi@huawei.com>
> CC: Mel Gorman <mgorman@suse.de>
> CC: linux-doc@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: linux-mm@kvack.org
>
> Lai Jiangshan (3):
>    memory_hotplug: fix missing nodemask management
>    slub, hotplug: ignore unrelated node's hot-adding and hot-removing
>    memory,hotplug: Don't modify the zone_start_pfn outside of
>      zone_span_writelock()
>
>   Documentation/memory-hotplug.txt |    5 ++-
>   include/linux/memory.h           |    1 +
>   mm/memory_hotplug.c              |   96 +++++++++++++++++++++++++++++++-------
>   mm/page_alloc.c                  |    3 +-
>   mm/slub.c                        |    4 +-
>   5 files changed, 87 insertions(+), 22 deletions(-)
>

