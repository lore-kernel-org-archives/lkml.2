Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1CPSSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:18:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57853 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1CPSSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=otL6dK9uuQlj4Nhko21e1eyyVeGmEX5SiI267iUfbjt7w4Y+VjuEDtjcsan7h/vye5
         z2VzrTz4wDInIkbIihnE1ofKMhlXIvW43EjOb+TJBzDzsnn/TiBNNvk7JwuRqxEcP2jL
         12h82YttD2VfjdbqSHv7y4VxD4DCV41Rb6BCQ=
From: Daniel Baluta <dbaluta@ixiacom.com>
To: paulmck@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] kmemleak: build kmemleak-test.c as a module-only
Date: Wed, 16 Mar 2011 20:16:34 +0200
Message-Id: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/kmemleak-test.c is used to provide an example of how kmemleak
tool works.

Memory is leaked at module unload-time, so building the test
in kernel (Y) makes the leaks impossible and the test useless.

Qualify DEBUG_KMEMLEAK_TEST config symbol with "depends on m",
to restrict module-only building.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
 lib/Kconfig.debug |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 689f311..6e9cacc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -407,11 +407,9 @@ config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
 
 config DEBUG_KMEMLEAK_TEST
 	tristate "Simple test for the kernel memory leak detector"
-	depends on DEBUG_KMEMLEAK
+	depends on DEBUG_KMEMLEAK && m
 	help
-	  Say Y or M here to build a test for the kernel memory leak
-	  detector. This option enables a module that explicitly leaks
-	  memory.
+	  This option enables a module that explicitly leaks memory.
 
 	  If unsure, say N.
 
-- 
1.7.1

