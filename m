Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2ICEmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 00:42:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46322 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2ICEmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 00:42:07 -0400
Date: Sun, 2 Sep 2012 21:41:33 -0700
From: Kent Overstreet <koverstreet@google.com>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] virtio-blk: Fix kconfig option
Message-ID: <20120903044133.GA9980@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
instead.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/block/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a796407..d4e1d12 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -521,7 +521,8 @@ config XEN_BLKDEV_BACKEND
 
 config VIRTIO_BLK
 	tristate "Virtio block driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	select VIRTIO
+	depends on EXPERIMENTAL
 	---help---
 	  This is the virtual block driver for virtio.  It can be used with
           lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
-- 
1.7.10.4

