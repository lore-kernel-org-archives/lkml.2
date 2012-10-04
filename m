Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2JDWIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:08:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44231 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab2JDVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:19:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <rdunlap@xenotime.net>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 48/56] remoteproc: select VIRTIO to avoid build breakage
Date: Thu,  4 Oct 2012 14:16:09 -0700
Message-Id: <20121004211157.579264666@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ohad Ben-Cohen <ohad@wizery.com>

commit 2ed6d29c725c4aead510b5c23f563795b265acf5 upstream.

drivers/built-in.o: In function `rproc_virtio_finalize_features':
remoteproc_virtio.c:(.text+0x2f9a02): undefined reference to `vring_transport_features'
drivers/built-in.o: In function `rproc_virtio_del_vqs':
remoteproc_virtio.c:(.text+0x2f9a74): undefined reference to `vring_del_virtqueue'
drivers/built-in.o: In function `rproc_virtio_find_vqs':
remoteproc_virtio.c:(.text+0x2f9c44): undefined reference to `vring_new_virtqueue'
drivers/built-in.o: In function `rproc_add_virtio_dev':
(.text+0x2f9e2c): undefined reference to `register_virtio_device'
drivers/built-in.o: In function `rproc_vq_interrupt':
(.text+0x2f9db7): undefined reference to `vring_interrupt'
drivers/built-in.o: In function `rproc_remove_virtio_dev':
(.text+0x2f9e9f): undefined reference to `unregister_virtio_device'

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -5,6 +5,7 @@ config REMOTEPROC
 	tristate
 	depends on EXPERIMENTAL
 	select FW_CONFIG
+	select VIRTIO
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"


