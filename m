Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565Ab2EOC0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:26:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:49873 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964899Ab2EOCSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 172/179] igb: Fix lack of flush after register write and before delay
Date: Mon, 14 May 2012 22:14:28 -0400
Message-ID: <1337048075-6132-173-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carolyn Wyborny <carolyn.wyborny@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 064b43304ed8ede8e13ff7b4338d09fd37bcffb1 upstream.

Register writes followed by a delay are required to have a flush
before the delay in order to commit the values to the register.  Without
the flush, the code following the delay may not function correctly.

Reported-by: Tong Ho <tong.ho@ericsson.com>
Reported-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
Tested-by:  Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/igb/e1000_82575.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index 4a32bed..a6ea91d 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -1554,6 +1554,7 @@ static s32 igb_reset_hw_82580(struct e1000_hw *hw)
 		ctrl |= E1000_CTRL_RST;
 
 	wr32(E1000_CTRL, ctrl);
+	wrfl();
 
 	/* Add delay to insure DEV_RST has time to complete */
 	if (global_device_reset)
-- 
1.7.9.6

