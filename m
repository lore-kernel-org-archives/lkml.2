Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab0K1JGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 04:06:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1892 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0K1JFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 04:05:54 -0500
From: Joe Perches <joe@perches.com>
To: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] zd1211rw: remove unnecessary [kv][mcz]alloc casts
Date: Sun, 28 Nov 2010 01:05:46 -0800
Message-Id: <704bdd89d630b364043ac7a9ec0a110d311a17a2.1290934782.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290934782.git.joe@perches.com>
References: <cover.1290934782.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 87a95bc..dfcebed 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -117,8 +117,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 
 	/* Allocate a single memory block for values and addresses. */
 	count16 = 2*count;
-	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
-		                   GFP_KERNEL);
+	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)), GFP_KERNEL);
 	if (!a16) {
 		dev_dbg_f(zd_chip_dev(chip),
 			  "error ENOMEM in allocation of a16\n");
-- 
1.7.3.2.245.g03276.dirty

