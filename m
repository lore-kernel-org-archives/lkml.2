Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1KOMkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:40:05 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6814 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1KOMkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:40:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Nov 2011 04:40:03 -0800
From: vbyravarasu@nvidia.com
To: linux-kernel@vger.kernel.org
Cc: venu byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] bcd: limit bin2bcd input value to lie between 0-99
Date: Tue, 15 Nov 2011 18:10:39 +0530
Message-Id: <1321360839-26451-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: venu byravarasu <vbyravarasu@nvidia.com>

If bin2bcd gets a value which is more than 100,
there are chances that it may store non decimal
value in the most significant nibble.

e.g. say val passed to bin2bcd is 112.
In that case the expected value to be returned by
this function is 12.
However, without the fix being added it would
be 112.

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

