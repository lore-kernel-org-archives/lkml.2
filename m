Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab1J0MH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:07:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64653 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1J0MHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:07:24 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] config: Add 'make kvmconfig'
Date: Thu, 27 Oct 2011 14:07:14 +0200
Message-Id: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 'make kvmconfig' which allows to add KVM guest support
to a config file.

This allows for easier testing of configurations under virtualized
environments.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---

Updated sym list to include everything required when starting from
'make allnoconfig' plus KGDB support.

 arch/x86/Kconfig         |   27 +++++++++++++++++++++++++++
 scripts/kconfig/Makefile |    6 +++++-
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..0b74528 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -520,6 +520,33 @@ config SCHED_OMIT_FRAME_POINTER
 
 	  If in doubt, say "Y".
 
+config KVMTOOL_TEST_ENABLE
+	bool "Enable options to create a bootable tools/kvm/ kernel"
+	select NET
+	select NETDEVICES
+	select PCI
+	select BLK_DEV
+	select NETWORK_FILESYSTEMS
+	select INET
+	select EXPERIMENTAL
+	select SERIAL_8250
+	select SERIAL_8250_CONSOLE
+	select IP_PNP
+	select IP_PNP_DHCP
+	select BINFMT_ELF
+	select PCI_MSI
+	select KGDB
+	select KGDB_SERIAL_CONSOLE
+	select VIRTIO
+	select VIRTIO_RING
+	select VIRTIO_PCI
+	select VIRTIO_BLK
+	select VIRTIO_CONSOLE
+	select VIRTIO_NET
+	select 9P_FS
+	select NET_9P
+	select NET_9P_VIRTIO
+
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
 	---help---
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 82d2eb2..356e551 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -3,7 +3,7 @@
 # These targets are used from top-level makefile
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config \
-	localmodconfig localyesconfig
+	localmodconfig localyesconfig kvmconfig
 
 ifdef KBUILD_KCONFIG
 Kconfig := $(KBUILD_KCONFIG)
@@ -33,6 +33,10 @@ silentoldconfig: $(obj)/conf
 	$(Q)mkdir -p include/generated
 	$< --$@ $(Kconfig)
 
+kvmconfig:
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/config -e KVMTOOL_TEST_ENABLE
+	@echo 'Kernel configuration modified to run as KVM guest.'
+
 # if no path is given, then use src directory to find file
 ifdef LSMOD
 LSMOD_F := $(LSMOD)
-- 
1.7.7.1

