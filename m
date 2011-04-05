Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1DER0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:26:53 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:49853
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927Ab1DER0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:26:50 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ6WGG-01-YWO-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <brgerst@gmail.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <suresh.b.siddha@intel.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH] x86-32, fpu: unbreak FPU exceptions on systems without SSE
Date: Tue, 5 Apr 2011 19:26:32 +0200
Message-ID: <1302024392-610677-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32bit systems without SSE, FPU exceptions in user mode cause Oopses,
BUGs, recursive faults and other nasty things.

This was caused by commit 58a992b9cbaf449aeebd3575c3695a9eb5d95b5e:
	x86-32, fpu: Rewrite fpu_save_init()
---
 arch/x86/include/asm/i387.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ef32890..c9e09ea 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -237,7 +237,7 @@ static inline void fpu_save_init(struct fpu *fpu)
 	} else if (use_fxsr()) {
 		fpu_fxsave(fpu);
 	} else {
-		asm volatile("fsave %[fx]; fwait"
+		asm volatile("fnsave %[fx]; fwait"
 			     : [fx] "=m" (fpu->state->fsave));
 		return;
 	}
-- 
1.5.6.5


