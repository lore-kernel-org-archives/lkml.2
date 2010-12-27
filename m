Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0L0Rbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 12:31:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:53265 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab0L0Rbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 12:31:43 -0500
From: David Sterba <dsterba@suse.cz>
To: mcarlson@broadcom.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Michael Chan <mchan@broadcom.com>
Subject: [PATCH] tg3: fix return value check in tg3_read_vpd()
Date: Mon, 27 Dec 2010 18:31:34 +0100
Message-Id: <1293471094-28976-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.3.4.626.g73e7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Matt Carlson <mcarlson@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 drivers/net/tg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 30ccbb6..6f97b7b 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -12658,7 +12658,7 @@ static void __devinit tg3_read_vpd(struct tg3 *tp)
 			cnt = pci_read_vpd(tp->pdev, pos,
 					   TG3_NVM_VPD_LEN - pos,
 					   &vpd_data[pos]);
-			if (cnt == -ETIMEDOUT || -EINTR)
+			if (cnt == -ETIMEDOUT || cnt == -EINTR)
 				cnt = 0;
 			else if (cnt < 0)
 				goto out_not_found;
-- 
1.7.3.4.626.g73e7b

