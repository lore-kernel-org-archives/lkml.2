Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0IJKlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:41:52 -0400
Received: from 87-119-183-14.tll.elisa.ee ([87.119.183.14]:3606 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378Ab0IJKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:41:50 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: tony.luck@intel.com
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ia64: unwind: remove preprocesser noise, and correct comment
Date: Fri, 10 Sep 2010 13:40:44 +0300
Message-Id: <1284115245-23876-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The expression in the comment was mis-bracketted.
There was also no need to introduce a coding-style breaking
macro for a single use, so just made it a static const.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/ia64/kernel/unwind.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/unwind.c b/arch/ia64/kernel/unwind.c
index b6c0e63..f47217b 100644
--- a/arch/ia64/kernel/unwind.c
+++ b/arch/ia64/kernel/unwind.c
@@ -1204,10 +1204,10 @@ desc_spill_sprel_p (unsigned char qp, unw_word t, unsigned char abreg, unw_word
 static inline unw_hash_index_t
 hash (unsigned long ip)
 {
-#	define hashmagic	0x9e3779b97f4a7c16UL	/* based on (sqrt(5)/2-1)*2^64 */
+	/* magic number = ((sqrt(5)-1)/2)*2^64 */
+	static const unsigned long hashmagic = 0x9e3779b97f4a7c16UL;
 
-	return (ip >> 4)*hashmagic >> (64 - UNW_LOG_HASH_SIZE);
-#undef hashmagic
+	return (ip >> 4) * hashmagic >> (64 - UNW_LOG_HASH_SIZE);
 }
 
 static inline long
-- 
1.7.2.rc1.37.gf8c40

