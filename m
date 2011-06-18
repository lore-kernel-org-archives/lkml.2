Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1FRVed (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 17:34:33 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:55915 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1FRVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 17:34:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Arnaud Lacombe <lacombar@gmail.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] um: Reinstate kernel version in generated .config
Date: Sat, 18 Jun 2011 23:34:25 +0200
Message-Id: <1308432865-9730-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0954828fcbf3bd13d593499b16b901a4e801b0b9 ("kconfig: replace
KERNELVERSION usage by the mainmenu's prompt") made the kernel version
disappear from the generated .config file when configuring for UML.
As UML's Kconfig doesn't have a mainmenu, kconfig falls back to the
default string "Linux Kernel Configuration".

Add a suitable mainmenu to the main UML Kconfig file to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/um/Kconfig.x86 |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index 8aae429..d31ecf3 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -1,3 +1,5 @@
+mainmenu "User Mode Linux/$SUBARCH $KERNELVERSION Kernel Configuration"
+
 source "arch/um/Kconfig.common"
 
 menu "UML-specific options"
-- 
1.7.0.4

