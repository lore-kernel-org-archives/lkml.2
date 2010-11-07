Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0KGOnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 09:43:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43405 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KGOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 09:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tXC54BaHQhs0cEeOZmSded1mZi5FVYxUSVhvsItIqvZ1KjQM4xyaBiFFjqq1kvRUCl
         MPv48unmWTIYXNcJ+RYGRc6Kn5c3fuqpG0ZLAY163AFHTzZ0pIx9/9DT+w909w8IG2BR
         QwM8v1CDQbOXDU2nOxlhLbQlSKUH05BJBooUI=
From: Tracey Dent <tdent48227@gmail.com>
To: bp@amd64.org
Cc: mchehab@redhat.com, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Drivers: edac: Makfile: Cleaned up Makefile
Date: Sun,  7 Nov 2010 09:43:33 -0500
Message-Id: <1289141013-1399-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.161.g3089c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs because -objs is
deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/edac/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index b378139..9b53eda 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -10,16 +10,16 @@ obj-$(CONFIG_EDAC)			:= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
 obj-$(CONFIG_EDAC_MCE)			+= edac_mce.o
 
-edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
-edac_core-objs	+= edac_module.o edac_device_sysfs.o
+edac_core-y	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
+edac_core-y	+= edac_module.o edac_device_sysfs.o
 
 ifdef CONFIG_PCI
-edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
+edac_core-y	+= edac_pci.o edac_pci_sysfs.o
 endif
 
 obj-$(CONFIG_EDAC_MCE_INJ)		+= mce_amd_inj.o
 
-edac_mce_amd-objs			:= mce_amd.o
+edac_mce_amd-y			:= mce_amd.o
 obj-$(CONFIG_EDAC_DECODE_MCE)		+= edac_mce_amd.o
 
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
-- 
1.7.3.1.104.gc752e

