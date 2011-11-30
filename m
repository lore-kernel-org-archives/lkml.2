Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1K3Itu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:49:50 -0500
Received: from mx5.orcon.net.nz ([219.88.242.55]:59559 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1K3Itt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:49:49 -0500
X-Greylist: delayed 2862 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Nov 2011 03:49:49 EST
From: Michael Cree <mcree@orcon.net.nz>
To: linux-alpha@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, 649468@bugs.debian.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] alpha: add io{read,write}{16,32}be functions
Date: Wed, 30 Nov 2011 21:01:40 +1300
Message-Id: <1322640100-14534-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.4.3
X-DSPAM-Check: by mx5.orcon.net.nz on Wed, 30 Nov 2011 21:02:05 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Nov 30 21:02:05 2011
X-DSPAM-Confidence: 0.8524
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are used in some PCI drivers with big-endian
MMIO space.

Admittedly it is almost certain that no one this side of the
Moon would use such a card in an Alpha but it does get us
closer to being able to build allyesconfig or allmodconfig,
and it enables the Debian default generic config to build.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/include/asm/io.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 56ff965..6365ef2 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -490,6 +490,11 @@ extern inline void writeq(u64 b, volatile void __iomem *addr)
 }
 #endif
 
+#define ioread16be(p) be16_to_cpu(ioread16(p))
+#define ioread32be(p) be32_to_cpu(ioread32(p))
+#define iowrite16be(v,p) iowrite16(cpu_to_be16(v), (p))
+#define iowrite32be(v,p) iowrite32(cpu_to_be32(v), (p))
+
 #define inb_p		inb
 #define inw_p		inw
 #define inl_p		inl
-- 
1.7.4.3

