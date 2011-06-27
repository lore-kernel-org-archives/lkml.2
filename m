Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1F0WRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:17:14 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49040 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab1F0WPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:15:40 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/4] um: Fix _FORTIFY_SOURCE=2 support for kernel modules
Date: Tue, 28 Jun 2011 00:15:28 +0200
Message-Id: <1309212931-19772-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When UML is compiled with _FORTIFY_SOURCE we have to
export all _chk() functions which are used in modules.
For now it's only the case for __sprintf_chk().

Tested-by: Florian Fainelli <florian@openwrt.org>
Reported-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/os-Linux/user_syms.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
index 05f5ea8..45ffe46 100644
--- a/arch/um/os-Linux/user_syms.c
+++ b/arch/um/os-Linux/user_syms.c
@@ -113,3 +113,8 @@ EXPORT_SYMBOL(__stack_smash_handler);
 
 extern long __guard __attribute__((weak));
 EXPORT_SYMBOL(__guard);
+
+#ifdef _FORTIFY_SOURCE
+extern int __sprintf_chk(char *str, int flag, size_t strlen, const char *format);
+EXPORT_SYMBOL(__sprintf_chk);
+#endif
-- 
1.7.5.4

