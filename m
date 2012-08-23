Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030251Ab2HWIWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:22:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35466 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687Ab2HWIWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:22:46 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5035E846.50707@jp.fujitsu.com>
Date: Thu, 23 Aug 2012 17:22:30 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Mel Gorman <mel@csn.ul.ie>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC V3 PATCH 00/25] memory,numa: introduce MOVABLE-dedicated
 node and online_movable for hotplug
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com> <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

Sorry for late reply.
I'm trying to apply your patchset into linux-3.6-rc3.
But I failed to apply them.
What is the based kernel that can apply your patch?

Thanks,
Yasuaki Ishimatsu


2012/08/06 18:22, Lai Jiangshan wrote:
> 	A) Introduction:
> 
> This patchset adds MOVABLE-dedicated node and online_movable for memory-management.
> 
> It is used for anti-fragmentation(hugepage, big-order allocation...),
> hot-removal-of-memory(virtualization, power-conserve, move memory between systems
> to make better utilities of memories).
> 
> 	B) User Interface:
> 
> When users(big system manager) need config some node/memory as MOVABLE:
> 	1 Use kernelcore_max_addr=XX when boot
> 	2 Use movable_online hotplug action when running
> We may introduce some more convenient interface, such as
> 	movable_node=NODE_LIST boot option.
> 
> 	C) Patches
> 
> Patch1-3      Fix problems of the current code.(all related with hotplug)
> Patch4        cleanup for node_state_attr
> Patch5        introduce N_MEMORY
> Patch6-18     use N_MEMORY instead N_HIGH_MEMORY.
>                The patches are separated by subsystem,
>                *these conversions was(must be) checked carefully*.
>                Patch18 also changes the node_states initialization
> Patch19       Add config to allow MOVABLE-dedicated node
> Patch20-24    Add kernelcore_max_addr
> Patch25       Add online_movable and online_kernel
> 
> 
> 	D) changes
> change V3-v2:
> 	Proper nodemask management
> 
> change V2-V1:
> 
> The original V1 patchset of MOVABLE-dedicated node is here:
> http://comments.gmane.org/gmane.linux.kernel.mm/78122
> 
> The new V2 adds N_MEMORY and a notion of "MOVABLE-dedicated node".
> And fix some related problems.
> 
> The orignal V1 patchset of "add online_movable" is here:
> https://lkml.org/lkml/2012/7/4/145
> 
> The new V2 discards the MIGRATE_HOTREMOVE approach, and use a more straight
> implementation(only 1 patch).
> 
> 
> Lai Jiangshan (21):
>    page_alloc.c: don't subtract unrelated memmap from zone's present
>      pages
>    memory_hotplug: fix missing nodemask management
>    slub, hotplug: ignore unrelated node's hot-adding and hot-removing
>    node: cleanup node_state_attr
>    node_states: introduce N_MEMORY
>    cpuset: use N_MEMORY instead N_HIGH_MEMORY
>    procfs: use N_MEMORY instead N_HIGH_MEMORY
>    memcontrol: use N_MEMORY instead N_HIGH_MEMORY
>    oom: use N_MEMORY instead N_HIGH_MEMORY
>    mm,migrate: use N_MEMORY instead N_HIGH_MEMORY
>    mempolicy: use N_MEMORY instead N_HIGH_MEMORY
>    hugetlb: use N_MEMORY instead N_HIGH_MEMORY
>    vmstat: use N_MEMORY instead N_HIGH_MEMORY
>    kthread: use N_MEMORY instead N_HIGH_MEMORY
>    init: use N_MEMORY instead N_HIGH_MEMORY
>    vmscan: use N_MEMORY instead N_HIGH_MEMORY
>    page_alloc: use N_MEMORY instead N_HIGH_MEMORY change the node_states
>      initialization
>    hotplug: update nodemasks management
>    numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
>    page_alloc: add kernelcore_max_addr
>    mm, memory-hotplug: add online_movable and online_kernel
> 
> Yasuaki Ishimatsu (4):
>    x86: get pg_data_t's memory from other node
>    x86: use memblock_set_current_limit() to set memblock.current_limit
>    memblock: limit memory address from memblock
>    memblock: compare current_limit with end variable at
>      memblock_find_in_range_node()
> 
>   Documentation/cgroups/cpusets.txt   |    2 +-
>   Documentation/kernel-parameters.txt |    9 ++
>   Documentation/memory-hotplug.txt    |   24 +++-
>   arch/x86/kernel/setup.c             |    4 +-
>   arch/x86/mm/init_64.c               |    4 +-
>   arch/x86/mm/numa.c                  |    8 +-
>   drivers/base/memory.c               |   19 ++-
>   drivers/base/node.c                 |   28 +++--
>   fs/proc/kcore.c                     |    2 +-
>   fs/proc/task_mmu.c                  |    4 +-
>   include/linux/cpuset.h              |    2 +-
>   include/linux/memblock.h            |    1 +
>   include/linux/memory.h              |    2 +
>   include/linux/memory_hotplug.h      |   13 ++-
>   include/linux/nodemask.h            |    5 +
>   init/main.c                         |    2 +-
>   kernel/cpuset.c                     |   32 +++---
>   kernel/kthread.c                    |    2 +-
>   mm/Kconfig                          |    8 ++
>   mm/hugetlb.c                        |   24 ++--
>   mm/memblock.c                       |   10 +-
>   mm/memcontrol.c                     |   18 ++--
>   mm/memory_hotplug.c                 |  232 ++++++++++++++++++++++++++++++++---
>   mm/mempolicy.c                      |   12 +-
>   mm/migrate.c                        |    2 +-
>   mm/oom_kill.c                       |    2 +-
>   mm/page_alloc.c                     |   96 +++++++++------
>   mm/page_cgroup.c                    |    2 +-
>   mm/slub.c                           |    4 +-
>   mm/vmscan.c                         |    4 +-
>   mm/vmstat.c                         |    4 +-
>   31 files changed, 437 insertions(+), 144 deletions(-)
> 


