Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab0IGEX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:23:28 -0400
Received: from [69.28.251.93] ([69.28.251.93]:48413 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab0IGEXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:23:24 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 6 Sep 2010 21:03:50 -0700
Subject: [PATCH 4/5] MIPS: Honor L2 bypass bit
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Message-Id: <fb6665b75d54bd58b8ac890106831e0f@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CP0 CONFIG2 bit 12 (L2B) is set, the L2 cache is disabled and
therefore Linux should not attempt to use it.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/sc-mips.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index 5ab5fa8..d072b25 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -79,6 +79,11 @@ static inline int __init mips_sc_probe(void)
 		return 0;
 
 	config2 = read_c0_config2();
+
+	/* bypass bit */
+	if (config2 & (1 << 12))
+		return 0;
+
 	tmp = (config2 >> 4) & 0x0f;
 	if (0 < tmp && tmp <= 7)
 		c->scache.linesz = 2 << tmp;
-- 
1.7.0.4

