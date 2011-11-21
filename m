Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1KUD6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 22:58:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49644 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1KUD6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 22:58:34 -0500
Date: Mon, 21 Nov 2011 03:58:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [patch] missing dependency for virtio_mmio
Message-ID: <20111121035831.GF2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver really depends on having readb/writeb/etc. - won't even build on
things like s390 or uml and on tile without PCI it'll build but panic
if you manage to run it...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 816ed08..4ae52fc 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -37,7 +37,7 @@ config VIRTIO_BALLOON
 
  config VIRTIO_MMIO
  	tristate "Platform bus driver for memory mapped virtio devices (EXPERIMENTAL)"
- 	depends on EXPERIMENTAL
+ 	depends on EXPERIMENTAL && HAS_IOMEM
  	select VIRTIO
  	select VIRTIO_RING
  	---help---
