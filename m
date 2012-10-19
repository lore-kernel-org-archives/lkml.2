Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2JSJ62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:58:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45697 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2JSJ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:58:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6031024"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: liuj97@gmail.com, len.brown@intel.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        muneda.takahiro@jp.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v2 0/3] acpi,memory-hotplug : implement framework for hot removing memory
Date: Fri, 19 Oct 2012 18:03:57 +0800
Message-Id: <1350641040-19434-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 17:58:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 17:58:01,
	Serialize complete at 2012/10/19 17:58:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The patch-set implements a framework for hot removing memory.

The memory device can be removed by 2 ways:
1. send eject request by SCI
2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject

In the 1st case, acpi_memory_disable_device() will be called.
In the 2nd case, acpi_memory_device_remove() will be called.
acpi_memory_device_remove() will also be called when we unbind the
memory device from the driver acpi_memhotplug or a driver initialization
fails.

acpi_memory_disable_device() has already implemented a code which
offlines memory and releases acpi_memory_info struct . But
acpi_memory_device_remove() has not implemented it yet.

So the patch prepares the framework for hot removing memory and
adds the framework into acpi_memory_device_remove().

The last version of this patchset is here:
https://lkml.org/lkml/2012/10/3/126

Changelos from v1 to v2:
  Patch1: use acpi_bus_trim() instead of acpi_bus_remove()
  Patch2: new patch, introduce a lock to protect the list
  Patch3: remove memory too when type is ACPI_BUS_REMOVAL_NORMAL
  Note: I don't send [Patch2-4 v1] in this series because they
  are no logical changes in these 3 patches.

Wen Congyang (2):
  acpi,memory-hotplug: call acpi_bus_trim() to remove memory device
  acpi,memory-hotplug: introduce a mutex lock to protect the list in
    acpi_memory_device

Yasuaki Ishimatsu (1):
  acpi,memory-hotplug : add memory offline code to
    acpi_memory_device_remove()

 drivers/acpi/acpi_memhotplug.c |   51 ++++++++++++++++++++++++++++++++--------
 1 files changed, 41 insertions(+), 10 deletions(-)

