Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1KPFKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 00:10:53 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1105 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1KPFKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 00:10:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 15 Nov 2011 21:10:51 -0800
From: vbyravarasu@nvidia.com
To: dbrownell@users.sourceforge.net, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, a.zummo@towertech.it, bunk@kernel.org,
        linux-kernel@vger.kernel.org
Cc: venu byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] bcd: limit bin2bcd input value to lie between 0-99
Date: Wed, 16 Nov 2011 10:41:32 +0530
Message-Id: <1321420292-26970-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: venu byravarasu <vbyravarasu@nvidia.com>

Current implementation of bin2bcd allows any value
between 0x0 to 0xF to be stored in the most significant
nibble of its returned value, against to the BCD limits
of 0 - 9. Hence fixing it.

e.g. say val passed to bin2bcd is 123.
In that case the expected value to be returned by
this function is 0x23.
However, without the fix being added, it would
return 0xC3.

Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>
---
 lib/bcd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/bcd.c b/lib/bcd.c
index d74257f..d715474 100644
--- a/lib/bcd.c
+++ b/lib/bcd.c
@@ -9,6 +9,7 @@ EXPORT_SYMBOL(bcd2bin);
 
 unsigned char bin2bcd(unsigned val)
 {
+	val %= 100;
 	return ((val / 10) << 4) + val % 10;
 }
 EXPORT_SYMBOL(bin2bcd);
-- 
1.7.1.1

