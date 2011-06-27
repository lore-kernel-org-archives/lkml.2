Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1F0WPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:15:45 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49050 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab1F0WPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:15:41 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/4] um: Reinstate kernel version in generated .config
Date: Tue, 28 Jun 2011 00:15:31 +0200
Message-Id: <1309212931-19772-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309212931-19772-1-git-send-email-richard@nod.at>
References: <1309212931-19772-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 0954828fcbf3bd13d593499b16b901a4e801b0b9 ("kconfig: replace
KERNELVERSION usage by the mainmenu's prompt") made the kernel version
disappear from the generated .config file when configuring for UML.
As UML's Kconfig doesn't have a mainmenu, kconfig falls back to the
default string "Linux Kernel Configuration".

Add a suitable mainmenu to the main UML Kconfig file to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
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
1.7.5.4

