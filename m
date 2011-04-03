Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab1DCNL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 09:11:29 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:49774 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab1DCNL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 09:11:27 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 1/2] m68k: bitops - offset == ((long)p - (long)vaddr) * 8
Date: Sun,  3 Apr 2011 15:11:16 +0200
Message-Id: <1301836277-30185-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hence use "offset" in find_next_{,zero_}bit(), like is already done for
find_next_{,zero_}bit_le()

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
---
 arch/m68k/include/asm/bitops_mm.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 9d69f6e..5bd3afa 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -220,8 +220,7 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 		offset += 32;
 	}
 	/* No zero yet, search remaining full bytes for a zero */
-	res = find_first_zero_bit(p, size - ((long)p - (long)vaddr) * 8);
-	return offset + res;
+	return offset + find_first_zero_bit(p, size - offset);
 }
 
 static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
@@ -267,8 +266,7 @@ static inline int find_next_bit(const unsigned long *vaddr, int size,
 		offset += 32;
 	}
 	/* No one yet, search remaining full bytes for a one */
-	res = find_first_bit(p, size - ((long)p - (long)vaddr) * 8);
-	return offset + res;
+	return offset + find_first_bit(p, size - offset);
 }
 
 /*
-- 
1.7.0.4

