Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab2IVBgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:36:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60631 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933154Ab2IVBgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:36:38 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+rjJADUz+rpKXk0aCwSb3zB+Ta+8ktC9pNQ/+3Qf
	wMhmNnsItxg/ib
From: Peter Huewe <peterhuewe@gmx.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>, stable@vger.kernel.org
Subject: [PATCH 2/2] extcon: unregister compat link on cleanup
Date: Sat, 22 Sep 2012 03:41:10 +0200
Message-Id: <1348278070-22202-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1348278070-22202-1-git-send-email-peterhuewe@gmx.de>
References: <1348278070-22202-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since extcon registers this compat link at device registration
(extcon_dev_register), we should probably remove them at deregistration/cleanup.

Cc: stable@vger.kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/extcon/extcon_class.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 6e914d0..7610b4e 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -575,6 +575,11 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
 			kfree(edev->cables);
 		}
 
+#if defined(CONFIG_ANDROID)
+		if (switch_class)
+			ret = class_compat_remove_link(switch_class, edev->dev,
+						       NULL);
+#endif /* CONFIG_ANDROID */
 		device_unregister(edev->dev);
 		put_device(edev->dev);
 	}
-- 
1.7.8.6

