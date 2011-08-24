Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1HXDfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab1HXDe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:34:58 -0400
Message-ID: <4E547155.8090709@redhat.com>
Date: Wed, 24 Aug 2011 11:34:45 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: [Patch] numa: introduce CONFIG_NUMA_SYSFS for drivers/base/node.c
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au>	<20110804152211.ea10e3e7.rdunlap@xenotime.net> <20110823143912.0691d442.akpm@linux-foundation.org>
In-Reply-To: <20110823143912.0691d442.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------080905050501060202020708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080905050501060202020708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Andrew,

Do you think my patch below is better?

Thanks!

------------->

--------------080905050501060202020708
Content-Type: text/plain;
 name="numa-depends-on-sysfs.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="numa-depends-on-sysfs.diff"

Introduce a new Kconfig CONFIG_NUMA_SYSFS for drivers/base/node.c
which just provides sysfs interface, so that when we select
CONFIG_NUMA, we don't have to enable the sysfs interface too.

This by the way fixes a randconfig build error when NUMA && !SYSFS.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 99a375a..e382338 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
-obj-$(CONFIG_NUMA)	+= node.o
+obj-$(CONFIG_NUMA_SYSFS)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
 ifeq ($(CONFIG_SYSFS),y)
diff --git a/mm/Kconfig b/mm/Kconfig
index f2f1ca1..77345e7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -340,6 +340,16 @@ choice
 	  benefit.
 endchoice
 
+config NUMA_SYSFS
+	bool "Enable NUMA sysfs interface for user-space"
+	depends on NUMA
+	depends on SYSFS
+	default y
+	help
+	  This enables NUMA sysfs interface, /sys/devices/system/node/*
+	  files, for user-space tools, like numactl. If you have enabled
+	  NUMA, probably you also need this one.
+
 #
 # UP and nommu archs use km based percpu allocator
 #

--------------080905050501060202020708--
