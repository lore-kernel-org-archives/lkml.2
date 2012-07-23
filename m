Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2GWByQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:54:16 -0400
Received: from ozlabs.org ([203.10.76.45]:39173 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab2GWByN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:54:13 -0400
Date: Mon, 23 Jul 2012 11:54:14 +1000
From: Anton Blanchard <anton@samba.org>
To: gregkh@linuxfoundation.org, kay@vrfy.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Enable devtmpfs by default
Message-ID: <20120723115414.724e0046@kryten>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


udev now requires CONFIG_DEVTMPFS so make it default to y.

I noticed this when booting a ppc64 pseries_defconfig on Fedora 17
and it paniced because it couldn't mount the root device.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/drivers/base/Kconfig
===================================================================
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -24,6 +24,7 @@ config UEVENT_HELPER_PATH
 config DEVTMPFS
 	bool "Maintain a devtmpfs filesystem to mount at /dev"
 	depends on HOTPLUG
+	default y
 	help
 	  This creates a tmpfs/ramfs filesystem instance early at bootup.
 	  In this filesystem, the kernel driver core maintains device
