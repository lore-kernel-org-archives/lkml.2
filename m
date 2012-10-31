Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965413Ab2JaL0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:26:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14146 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935399Ab2JaL0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:26:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6108772"
Message-ID: <50910C39.70305@cn.fujitsu.com>
Date: Wed, 31 Oct 2012 19:32:09 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <liuj97@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, rjw@sisk.pl,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [Patch v4 0/8] bugfix for memory hotplug
References: <1351682594-17347-1-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1351682594-17347-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 19:25:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 19:25:39,
	Serialize complete at 2012/10/31 19:25:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/31/2012 07:23 PM, Wen Congyang Wrote:
> The last version is here:
>     https://lkml.org/lkml/2012/10/19/56
> 
> Note: patch 1-3 are in -mm tree and I don't touch them. The other patches
> except patch6 are also in mm tree. Patch 6 is not touched.
> 
> Changes from v3 to v4:
>   Patch4: use dynamically allocated memory instead of static array.
>   Patch5: merge [patchv3 2-3] into a single patch, and update it as we use
>           dynamically allocated memory
>   Patch7: merge [patchv3 5-6] into a single patch
>   Patch8: merge [patchv3 9] and its fix into a patch

Note:
The patch from Michal Hocko <mhocko@suse.cz> is not merged into patch8

Thanks
Wen Congyang

> 
> Changes from v2 to v3:
>   Merge the bug fix from ishimatsu to this patchset(Patch 1-3)
>   Patch 3: split it from patch as it fixes another bug.
>   Patch 4: new patch, and fix bad-page state when hotadding a memory
>            device after hotremoving it. I forgot to post this patch in v2.
>   Patch 6: update it according to Dave Hansen's comment.
> 
> Changes from v1 to v2:
>   Patch 1: updated according to kosaki's suggestion
> 
>   Patch 2: new patch, and update mce_bad_pages when removing memory.
> 
>   Patch 4: new patch, and fix a NR_FREE_PAGES mismatch, and this bug
>            cause oom in my test.
> 
>   Patch 5: new patch, and fix a new bug. When repeating to online/offline
>            pages, the free pages will continue to decrease. 
> 
> Wen Congyang (6):
>   memory-hotplug: auto offline page_cgroup when onlining memory block
>     failed
>   memory-hotplug: fix NR_FREE_PAGES mismatch
>   numa: convert static memory to dynamically allocated memory for per
>     node device
>   clear the memory to store struct page
>   memory-hotplug: current hwpoison doesn't support memory offline
>   memory-hotplug: allocate zone's pcp before onlining pages
> 
> Yasuaki Ishimatsu (2):
>   memory hotplug: suppress "Device memoryX does not have a release()
>     function" warning
>   suppress "Device nodeX does not have a release() function" warning
> 
>  arch/powerpc/kernel/sysfs.c    |  4 +--
>  drivers/base/memory.c          |  9 ++++++-
>  drivers/base/node.c            | 56 ++++++++++++++++++++++++++++++------------
>  include/linux/node.h           |  2 +-
>  include/linux/page-isolation.h | 10 +++++---
>  mm/hugetlb.c                   |  4 +--
>  mm/memory-failure.c            |  2 +-
>  mm/memory_hotplug.c            | 13 +++++++---
>  mm/page_alloc.c                | 37 +++++++++++++++++++++-------
>  mm/page_cgroup.c               |  3 +++
>  mm/page_isolation.c            | 27 ++++++++++++++------
>  mm/sparse.c                    | 25 ++++++++++++++++++-
>  12 files changed, 144 insertions(+), 48 deletions(-)
> 

