Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab2KZRNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:13:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab2KZRM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Huewe <peterhuewe@gmx.de>, Chanwoo Choi <cw00.choi@samsung.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 209/270] extcon: unregister compat link on cleanup
Date: Mon, 26 Nov 2012 14:58:19 -0200
Message-Id: <1353949160-26803-210-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Huewe <peterhuewe@gmx.de>

commit 824a1bc045cef278aec15bef35d8d0b59ce77856 upstream.

Since extcon registers this compat link at device registration
(extcon_dev_register), we should probably remove them at deregistration/cleanup.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[ herton: file name is extcon_class.c on 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/extcon/extcon_class.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 01bac36..0a710b0 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -575,6 +575,10 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
 			kfree(edev->cables);
 		}
 
+#if defined(CONFIG_ANDROID)
+		if (switch_class)
+			class_compat_remove_link(switch_class, edev->dev, NULL);
+#endif
 		device_unregister(edev->dev);
 		put_device(edev->dev);
 	}
-- 
1.7.9.5

