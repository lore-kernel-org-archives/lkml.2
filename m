Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284Ab2D0OeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:34:13 -0400
Received: from mailgw13.technion.ac.il ([132.68.225.13]:27084 "EHLO
	mailgw13.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab2D0OeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:34:11 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2012 10:34:10 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFAMarmk+ERM5e/2dsb2JhbABErjyDLoEHgwkogReIH7N7iQmRQwSIXZM2iiqCaw
X-IronPort-AV: E=Sophos;i="4.75,491,1330898400"; 
   d="scan'208";a="6888824"
From: Nadav Amit <namit@cs.technion.ac.il>
To: avi@redhat.com, mtosatti@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: Emulator: Opcode 0x80 gets a byte immediate
Date: Fri, 27 Apr 2012 17:23:36 +0300
Message-Id: <1335536616-8524-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The single byte opcode 0x80 should get a byte immediate.
The previous emulation is broken for opcode 0x80.
---
 arch/x86/kvm/emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8375622..dd53e53 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3464,7 +3464,7 @@ static struct opcode opcode_table[256] = {
 	/* 0x70 - 0x7F */
 	X16(D(SrcImmByte)),
 	/* 0x80 - 0x87 */
-	G(ByteOp | DstMem | SrcImm | ModRM | Group, group1),
+	G(ByteOp | DstMem | SrcImmByte | ModRM | Group, group1),
 	G(DstMem | SrcImm | ModRM | Group, group1),
 	G(ByteOp | DstMem | SrcImm | ModRM | No64 | Group, group1),
 	G(DstMem | SrcImmByte | ModRM | Group, group1),
-- 
1.7.4.1

