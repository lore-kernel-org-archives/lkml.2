Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2F0FkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:40:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40162 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2F0Fj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:39:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEA9C88.1070800@jp.fujitsu.com>
Date: Wed, 27 Jun 2012 14:39:20 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <len.brown@intel.com>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [RFC PATCH 0/12] memory-hotplug : hot-remove physical memory
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series aims to support physical memory hot-remove.

  [RFC PATCH 1/12] memory-hotplug : rename remove_memory to offline_memory
  [RFC PATCH 2/12] memory-hogplug : check memory offline in offline_pages
  [RFC PATCH 3/12] memory-hotplug : add physical memory hotplug code to acpi_memory_device_remove
  [RFC PATCH 4/12] memory-hotplug : remove /sys/firmware/memmap/X sysfs
  [RFC PATCH 5/12] memory hotplug : does not release memory region in PAGES_PER_SECTION chunks
  [RFC PATCH 6/12] memory-hotplug : remove_memory calls __remove_pages
  [RFC PATCH 7/12] memory-hotplug : check page type in get_page_bootmem
  [RFC PATCH 8/12] memory-hotplug : move register_page_bootmem_info_node and put_page_bootmem for
sparse-vmemmap
  [RFC PATCH 9/12] memory-hotplug : implement register_page_bootmem_info_section of sparse-vmemmap
  [RFC PATCH 10/12] memory-hotplug : free memmap of sparse-vmemmap
  [RFC PATCH 11/12] memory-hotplug : add node_device_release
  [RFC PATCH 12/12] memory-hotplug : remove sysfs file of node

Even if you apply these patches, you cannot remove the physical memory
completely since these patches are still under development. I want you to
cooperate to improve the physical memory hot-remove. So please review these
patches and give your comment/idea.

The patches can free/remove following things:

  - acpi_memory_info                          : [RFC PATCH 3/12]
  - /sys/firmware/memmap/X/{end, start, type} : [RFC PATCH 4/12]
  - iomem_resource                            : [RFC PATCH 5/12]
  - mem_section and related sysfs files       : [RFC PATCH 6-10/12]
  - node and related sysfs files              : [RFC PATCH 11-12/12]

The patches cannot do following things yet:

  - page table of removed memory

If you find lack of function for physical memory hot-remove, please let me
know.

---

 arch/powerpc/platforms/pseries/hotplug-memory.c |   16 +-
 arch/x86/mm/init_64.c                           |  142 ++++++++++++++++++++++++
 drivers/acpi/acpi_memhotplug.c                  |   25 +++-
 drivers/base/memory.c                           |   24 +++-
 drivers/base/node.c                             |    7 +
 drivers/firmware/memmap.c                       |   71 ++++++++++++
 include/linux/firmware-map.h                    |    6 +
 include/linux/memory.h                          |    1
 include/linux/memory_hotplug.h                  |   17 --
 include/linux/mm.h                              |    5
 mm/memory_hotplug.c                             |  101 +++++++++++++----
 mm/sparse.c                                     |    5
 12 files changed, 374 insertions(+), 46 deletions(-)


