Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2LLSU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:20:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56087 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754926Ab2LLSU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:20:58 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 09/26] mn10300: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:18:58 -0800
Message-Id: <58e24d456b5d947a7e59718be0404724a0f70652.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Consolidate multiple printks into a one.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mn10300/kernel/traps.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index b900e5a..d263b70 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -256,13 +256,13 @@ void show_trace(unsigned long *sp)
 		}
 
 		if (__kernel_text_address(addr)) {
-			printk(" [<%08lx>]", addr);
+			const char *known = "";
 			if (stack >= raslot)
 				raslot = ULONG_MAX;
 			else
-				printk(" ?");
-			print_symbol(" %s", addr);
-			printk("\n");
+				known = " ?";
+			printk(" [<%08lx>]%s %pSR\n",
+			       addr, known, (void *)addr);
 		}
 	}
 
-- 
1.7.8.112.g3fd21

