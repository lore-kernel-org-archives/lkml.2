Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab2CaJwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 05:52:18 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:44893 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2CaJwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 05:52:12 -0400
Message-ID: <40f4b91c5200771f223966f368095c63.squirrel@webmail.greenhost.nl>
Date: Sat, 31 Mar 2012 20:52:09 +1100
Subject: [PATCH] net: bpf_jit: fix BPF_S_ALU_AND_K compilation
From: "Indan Zupancic" <indan@nul.nu>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -0.7
X-Scan-Signature: 4052b6d1c9976086d5ab5ce040fcf5b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Finally, after much searching I found one little bug.

[PATCH] net: bpf_jit: fix BPF_S_ALU_AND_K compilation

Small typo resulted in bad code generation for certain
values of K for the BPF_S_ALU_AND_K instruction.

Signed-off-by: Indan Zupancic <indan@nul.nu>
---

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 7c1b765..28bc807 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -289,7 +289,7 @@ void bpf_jit_compile(struct sk_filter *fp)
 					EMIT2(0x24, K & 0xFF); /* and imm8,%al */
 				} else if (K >= 0xFFFF0000) {
 					EMIT2(0x66, 0x25);	/* and imm16,%ax */
-					EMIT2(K, 2);
+					EMIT(K, 2);
 				} else {
 					EMIT1_off32(0x25, K);	/* and imm32,%eax */
 				}


