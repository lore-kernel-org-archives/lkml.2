Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1KXHEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:04:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45928 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1KXHEs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:04:48 -0500
Message-ID: <1322118279.2839.255.camel@deadeye>
Subject: [PATCH] topology: Provide CPU topology in sysfs in !SMP
 configurations
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Marcus Osdoba <marcus.osdoba@googlemail.com>, 649216@bugs.debian.org
Date: Thu, 24 Nov 2011 07:04:39 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should provide topology information to userland even if it's not
very interesting.  The current code appears to work properly for !SMP
(tested on i386).

Reference: http://bugs.debian.org/649216
Reported-by: Marcus Osdoba <marcus.osdoba@googlemail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 99a375a..1334d89 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -3,7 +3,8 @@
 obj-y			:= core.o sys.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
-			   attribute_container.o transport_class.o
+			   attribute_container.o transport_class.o \
+			   topology.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
@@ -12,7 +13,6 @@ obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
-obj-$(CONFIG_SMP)	+= topology.o
 ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
 endif
-- 
1.7.7.3


