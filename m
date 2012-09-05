Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab2IEAHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:07:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35414 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2IEAHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:07:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>
Subject: [patch 3/3] CONFIG_HOTPLUG should be always on
Date: Tue,  4 Sep 2012 17:01:08 -0700
Message-Id: <20120904235155.218456468@clark.kroah.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120904234803.554552301@clark.kroah.org>
References: <20120904234803.554552301@clark.kroah.org>
Content-Disposition: inline; filename=config_hotplug-should-be-always-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

CONFIG_HOTPLUG is a very old option, back when we had static systems and it was
odd that any type of device would be removed or added after the system had
started up.  It is quite hard to disable it these days, and even if you do, it
only saves you about 200 bytes.  However, if it is disabled, lots of bugs show
up because it is almost never tested if the option is disabled.

This is a step to eventually just remove the option entirely, which will clean
up all of the devinit* variable and function pointer options, that everyone
(myself include) ends up getting wrong eventually, causing real problems when
memory segments are removed yet we don't expect them to be.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>

---
 init/Kconfig |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1201,13 +1201,7 @@ config KALLSYMS_ALL
 	   Say N unless you really need all symbols.
 
 config HOTPLUG
-	bool "Support for hot-pluggable devices" if EXPERT
-	default y
-	help
-	  This option is provided for the case where no hotplug or uevent
-	  capabilities is wanted by the kernel.  You should only consider
-	  disabling this option for embedded systems that do not use modules, a
-	  dynamic /dev tree, or dynamic device discovery.  Just say Y.
+	def_bool y
 
 config PRINTK
 	default y


