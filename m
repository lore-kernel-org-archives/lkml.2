Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2LLSUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:20:34 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57951 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754716Ab2LLSUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:20:30 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 06/26] c6x: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:18:55 -0800
Message-Id: <f63dcf97f1fad4b82e64fb837a62025f1271ad0a.1355335227.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/c6x/kernel/traps.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/c6x/kernel/traps.c b/arch/c6x/kernel/traps.c
index 1be74e5..349cae0 100644
--- a/arch/c6x/kernel/traps.c
+++ b/arch/c6x/kernel/traps.c
@@ -382,8 +382,7 @@ static void show_trace(unsigned long *stack, unsigned long *endstack)
 			if (i % 5 == 0)
 				pr_debug("\n	    ");
 #endif
-			pr_debug(" [<%08lx>]", addr);
-			print_symbol(" %s\n", addr);
+			pr_debug(" [<%08lx>] %pSR\n", addr, (void *)addr);
 			i++;
 		}
 	}
-- 
1.7.8.112.g3fd21

