Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2ACWnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:43:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471Ab2ACWnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:43:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:25 2012
Message-Id: <20120103223325.902515848@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [58/75] sparc64: Fix masking and shifting in VIS fpcmp emulation.
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 2e8ecdc008a16b9a6c4b9628bb64d0d1c05f9f92 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/visemul.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -713,17 +713,17 @@ static void pcmp(struct pt_regs *regs, u
 			s16 b = (rs2 >> (i * 16)) & 0xffff;
 
 			if (a > b)
-				rd_val |= 1 << i;
+				rd_val |= 8 >> i;
 		}
 		break;
 
 	case FCMPGT32_OPF:
 		for (i = 0; i < 2; i++) {
-			s32 a = (rs1 >> (i * 32)) & 0xffff;
-			s32 b = (rs2 >> (i * 32)) & 0xffff;
+			s32 a = (rs1 >> (i * 32)) & 0xffffffff;
+			s32 b = (rs2 >> (i * 32)) & 0xffffffff;
 
 			if (a > b)
-				rd_val |= 1 << i;
+				rd_val |= 2 >> i;
 		}
 		break;
 
@@ -733,17 +733,17 @@ static void pcmp(struct pt_regs *regs, u
 			s16 b = (rs2 >> (i * 16)) & 0xffff;
 
 			if (a <= b)
-				rd_val |= 1 << i;
+				rd_val |= 8 >> i;
 		}
 		break;
 
 	case FCMPLE32_OPF:
 		for (i = 0; i < 2; i++) {
-			s32 a = (rs1 >> (i * 32)) & 0xffff;
-			s32 b = (rs2 >> (i * 32)) & 0xffff;
+			s32 a = (rs1 >> (i * 32)) & 0xffffffff;
+			s32 b = (rs2 >> (i * 32)) & 0xffffffff;
 
 			if (a <= b)
-				rd_val |= 1 << i;
+				rd_val |= 2 >> i;
 		}
 		break;
 
@@ -753,17 +753,17 @@ static void pcmp(struct pt_regs *regs, u
 			s16 b = (rs2 >> (i * 16)) & 0xffff;
 
 			if (a != b)
-				rd_val |= 1 << i;
+				rd_val |= 8 >> i;
 		}
 		break;
 
 	case FCMPNE32_OPF:
 		for (i = 0; i < 2; i++) {
-			s32 a = (rs1 >> (i * 32)) & 0xffff;
-			s32 b = (rs2 >> (i * 32)) & 0xffff;
+			s32 a = (rs1 >> (i * 32)) & 0xffffffff;
+			s32 b = (rs2 >> (i * 32)) & 0xffffffff;
 
 			if (a != b)
-				rd_val |= 1 << i;
+				rd_val |= 2 >> i;
 		}
 		break;
 
@@ -773,17 +773,17 @@ static void pcmp(struct pt_regs *regs, u
 			s16 b = (rs2 >> (i * 16)) & 0xffff;
 
 			if (a == b)
-				rd_val |= 1 << i;
+				rd_val |= 8 >> i;
 		}
 		break;
 
 	case FCMPEQ32_OPF:
 		for (i = 0; i < 2; i++) {
-			s32 a = (rs1 >> (i * 32)) & 0xffff;
-			s32 b = (rs2 >> (i * 32)) & 0xffff;
+			s32 a = (rs1 >> (i * 32)) & 0xffffffff;
+			s32 b = (rs2 >> (i * 32)) & 0xffffffff;
 
 			if (a == b)
-				rd_val |= 1 << i;
+				rd_val |= 2 >> i;
 		}
 		break;
 	}


