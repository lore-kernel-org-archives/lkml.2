Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab2JIPYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:24:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2JIPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:23:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/9] ARM: Fix another build warning in arch/arm/mm/alignment.c
Date: Tue,  9 Oct 2012 17:22:57 +0200
Message-Id: <1349796183-30648-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:6rA3BURTRlyriapdK4eKUWwdn8mcvoqR8ZK9pWIIz4o
 0h2wKJrC5Lm6AlBGtWx6fmqBLVEtHsl0WNZUWPzCMGQAX9tNRj
 qZZGr9bUUwdDwQ7VP5kVX48JuDMhopBtO0CCq1SfDZ7X/F0yvQ
 3NXVYMLTLhQNJKM1bPJpjYXxF+Pc2itCCex+4Jxn/x+NIEFbHT
 ozHne36CAp3tA4FmwQyTHTQ2Rn6QgfygmlomAFshM3pGUcAGoQ
 kQu+o5p4bBRl3sERPsdG4sw0b44INWXZ6cZG46BbTUwLli4clI
 rVN/TT4O1iVQhN/ocA2k/8mBcpHBEqei7Lh0F5m5zIP49zFzyz
 ybg+JG4u3iA9/9rUuby6htMNjR/PP7dGMCqWs+/D66vIfFUHb4
 zeKr43bQlvAxkPiil33XQTlbiZlmXKpQoE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One such warning was recently fixed in a761cebf "ARM: Fix build warning
in arch/arm/mm/alignment.c" but only for the thumb2 case, this fixes
the other half.

arch/arm/mm/alignment.c: In function 'do_alignment':
arch/arm/mm/alignment.c:327:15: error: 'offset.un' may be used uninitialized in this function
arch/arm/mm/alignment.c:748:21: note: 'offset.un' was declared here

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mm/alignment.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index b9f60eb..023f4437 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -856,8 +856,10 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		if (thumb2_32b) {
 			offset.un = 0;
 			handler = do_alignment_t32_to_handler(&instr, regs, &offset);
-		} else
+		} else {
+			offset.un = 0;
 			handler = do_alignment_ldmstm;
+		}
 		break;
 
 	default:
-- 
1.7.10

