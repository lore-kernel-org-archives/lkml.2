Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2ICFWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:22:03 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35034 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2ICFV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:21:26 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 22:21:21 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 4/5] x86, defconfig: Turn off CONFIG_BLK_DEV_RAM
Message-ID: <2521e983a63595cd7a331236d929577660f89c72.1346649518.git.josh@joshtriplett.org>
References: <cover.1346649518.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1346649518.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vast majority of systems either use initramfs or mount a root
filesystem directly from the kernel.  Distros have defaulted to
initramfs for years.  Only highly specialized systems would use an
actual filesystem-image initrd at this point, and such systems don't
rely on defconfig anyway.  Drop initrd support (and specifically RAM
block device support) from the defconfigs.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/configs/i386_defconfig   |    2 --
 arch/x86/configs/x86_64_defconfig |    2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index d833bb6..a6533a2 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -144,8 +144,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 7ddcd99..18f3cc4 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -144,8 +144,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
-- 
1.7.10.4

