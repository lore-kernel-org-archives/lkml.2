Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2GTHCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:02:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56917 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab2GTHCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:02:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,621,1336320000"; 
   d="scan'208";a="5444811"
Message-ID: <5009038A.4090001@cn.fujitsu.com>
Date: Fri, 20 Jul 2012 15:06:50 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
CC: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [RFC PATCH 0/8] memory-hotplug : hot-remove physical memory(clear
 page table)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/20 15:02:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/20 15:02:47,
	Serialize complete at 2012/07/20 15:02:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series aims to support physical memory hot-remove(clear page table).

This patch series base on ishimatsu's patch series. You can get it here:
http://www.spinics.net/lists/linux-acpi/msg36804.html

The patches can remove following things:
  - page table of removed memory

If you find lack of function for physical memory hot-remove, please let me
know.

Note:
* The patch "remove memory info from list before freeing it" is being disccussed
  in other thread. But for testing the patch series, the patch is needed.
  So I added the patch as [PATCH 0/8].
* You need to apply ishimatsu's patch series first before applying this patch
  series.

Wen Congyang (8):
  memory-hotplug: store the node id in acpi_memory_device
  memory-hotplug: offline memory only when it is onlined
  memory-hotplug: call remove_memory() to cleanup when removing memory
    device
  memory-hotplug: export the function acpi_bus_remove()
  memory-hotplug: call acpi_bus_remove() to remove memory device
  memory-hotplug: introduce new function arch_remove_memory()
  x86: make __split_large_page() generally avialable
  memory-hotplug: implement arch_remove_memory()

 arch/ia64/mm/init.c                  |   16 ++++
 arch/powerpc/mm/mem.c                |   14 +++
 arch/s390/mm/init.c                  |    8 ++
 arch/sh/mm/init.c                    |   15 +++
 arch/tile/mm/init.c                  |    8 ++
 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/mm/init_32.c                |   10 ++
 arch/x86/mm/init_64.c                |  160 ++++++++++++++++++++++++++++++++++
 arch/x86/mm/pageattr.c               |   47 +++++-----
 drivers/acpi/acpi_memhotplug.c       |   24 ++++--
 drivers/acpi/scan.c                  |    3 +-
 include/acpi/acpi_bus.h              |    1 +
 include/linux/memory_hotplug.h       |    1 +
 mm/memory_hotplug.c                  |    2 +-
 14 files changed, 280 insertions(+), 30 deletions(-)

