Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1KVNkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:40:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44565 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1KVNkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:40:00 -0500
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH] mfd: tps65910: Handle clear-mask correctly
Date: Tue, 22 Nov 2011 14:39:51 +0100
Message-Id: <1321969191-8604-2-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321969191-8604-1-git-send-email-marcus.folkesson@gmail.com>
References: <Marcus Folkesson <marcus.folkesson@gmail.com>
 <1321969191-8604-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is not actually cleaing the bitmask.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/mfd/tps65910.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 6f5b8cf..c1da84b 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -120,7 +120,7 @@ int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask)
 		goto out;
 	}
 
-	data &= mask;
+	data &= ~mask;
 	err = tps65910_i2c_write(tps65910, reg, 1, &data);
 	if (err)
 		dev_err(tps65910->dev, "write to reg %x failed\n", reg);
-- 
1.7.5.4

