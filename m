Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1DZP6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:58:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50022 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1DZP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jgtgk/gfdcW+qs5NUO8MZCjnQRxXHnemNOgcwYhiOEYY0/AyNQq4WKzzVS+Ou78RwJ
         ipzseBvghQMtiuMwCJz5ON2c4xUD+cqCnJLj5r5xHtM6ToZAygZYZVroGK3KyKY9Bd9+
         Po8wP7dpuq+fXUcQYTSwxwbxlB5Y6zf0cNiJk=
Subject: [PATCH] ARM: ARCH_SMDK2410: add select S3C_DEV_USB_HOST to fix
 build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 23:58:33 +0800
Message-ID: <1303833513.24142.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add select S3C_DEV_USB_HOST for ARCH_SMDK2410 to fix below build error.

  LD      .tmp_vmlinux1
arch/arm/mach-s3c2410/built-in.o:(.init.data+0x30): undefined reference to `s3c_device_ohci'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-s3c2410/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2410/Kconfig b/arch/arm/mach-s3c2410/Kconfig
index 7245a55..81b45e6 100644
--- a/arch/arm/mach-s3c2410/Kconfig
+++ b/arch/arm/mach-s3c2410/Kconfig
@@ -66,6 +66,7 @@ menu "S3C2410 Machines"
 config ARCH_SMDK2410
 	bool "SMDK2410/A9M2410"
 	select CPU_S3C2410
+	select S3C_DEV_USB_HOST
 	select MACH_SMDK
 	help
 	   Say Y here if you are using the SMDK2410 or the derived module A9M2410
-- 
1.7.1



