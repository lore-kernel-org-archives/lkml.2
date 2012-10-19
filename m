Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2JSIGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:06:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39569 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2JSIGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:06:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <508109F2.1080402@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 17:06:10 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <wency@cn.fujitsu.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3 0/9] bugfix for memory hotplug
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wen,

Some bug fix patches have been merged into linux-next.
So the patches confuse me.
Why did you send same patches again?

Thanks,
Yasuaki Ishimatsu

2012/10/19 15:46, wency@cn.fujitsu.com wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
> 
> Changes from v2 to v3:
>    Merge the bug fix from ishimatsu to this patchset(Patch 1-3)
>    Patch 3: split it from patch as it fixes another bug.
>    Patch 4: new patch, and fix bad-page state when hotadding a memory
>             device after hotremoving it. I forgot to post this patch in v2.
>    Patch 6: update it according to Dave Hansen's comment.
> 
> Changes from v1 to v2:
>    Patch 1: updated according to kosaki's suggestion
> 
>    Patch 2: new patch, and update mce_bad_pages when removing memory.
> 
>    Patch 4: new patch, and fix a NR_FREE_PAGES mismatch, and this bug
>             cause oom in my test.
> 
>    Patch 5: new patch, and fix a new bug. When repeating to online/offline
>             pages, the free pages will continue to decrease.
> 
> Wen Congyang (6):
>    clear the memory to store struct page
>    memory-hotplug: skip HWPoisoned page when offlining pages
>    memory-hotplug: update mce_bad_pages when removing the memory
>    memory-hotplug: auto offline page_cgroup when onlining memory block
>      failed
>    memory-hotplug: fix NR_FREE_PAGES mismatch
>    memory-hotplug: allocate zone's pcp before onlining pages
> 
> Yasuaki Ishimatsu (3):
>    suppress "Device memoryX does not have a release() function" warning
>    suppress "Device nodeX does not have a release() function" warning
>    memory-hotplug: flush the work for the node when the node is offlined
> 
>   drivers/base/memory.c          |    9 ++++++++-
>   drivers/base/node.c            |   11 +++++++++++
>   include/linux/page-isolation.h |   10 ++++++----
>   mm/memory-failure.c            |    2 +-
>   mm/memory_hotplug.c            |   14 ++++++++------
>   mm/page_alloc.c                |   37 ++++++++++++++++++++++++++++---------
>   mm/page_cgroup.c               |    3 +++
>   mm/page_isolation.c            |   27 ++++++++++++++++++++-------
>   mm/sparse.c                    |   22 +++++++++++++++++++++-
>   9 files changed, 106 insertions(+), 29 deletions(-)
> 


