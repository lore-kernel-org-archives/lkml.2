Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2EVN1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:27:42 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52562 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab2EVN1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:27:14 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 6/6] remoteproc: Make REMOTEPROC_ELF a sparate Kconfig
Date: Tue, 22 May 2012 15:26:57 +0200
Message-Id: <1337693217-15466-7-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Make REMOTEPROC_ELF a separate Kconfig entry.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/Kconfig                 |    6 ++++++
 drivers/remoteproc/Makefile                |    2 +-
 drivers/remoteproc/remoteproc_core.c       |    1 +
 drivers/remoteproc/remoteproc_elf_loader.c |    2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 24d880e..316a726 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -5,11 +5,17 @@ config REMOTEPROC
 	tristate
 	depends on EXPERIMENTAL
 
+config REMOTEPROC_ELF
+	tristate
+	depends on REMOTEPROC && EXPERIMENTAL
+	default m
+
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
 	depends on ARCH_OMAP4
 	depends on OMAP_IOMMU
 	select REMOTEPROC
+	select REMOTEPROC_ELF
 	select OMAP_MBOX_FWK
 	select RPMSG
 	help
diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index 934ce6e..047d286 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -6,5 +6,5 @@ obj-$(CONFIG_REMOTEPROC)		+= remoteproc.o
 remoteproc-y				:= remoteproc_core.o
 remoteproc-y				+= remoteproc_debugfs.o
 remoteproc-y				+= remoteproc_virtio.o
-remoteproc-y				+= remoteproc_elf_loader.o
+obj-$(CONFIG_REMOTEPROC_ELF)		+= remoteproc_elf_loader.o
 obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 75984ad..7aca0d7 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -187,6 +187,7 @@ void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
 
 	return ptr;
 }
+EXPORT_SYMBOL(rproc_da_to_va);
 
 static int
 __rproc_handle_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index b90aeff..b726bfe 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -278,3 +278,5 @@ struct rproc_fw_ops rproc_elf_fw_ops = {
 	.owner = THIS_MODULE
 };
 EXPORT_SYMBOL(rproc_elf_fw_ops);
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Generic Remote Processor ELF Firmware handling");
-- 
1.7.9.5

