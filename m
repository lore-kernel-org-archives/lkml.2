Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1KUGDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 01:03:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46067 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1KUGDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 01:03:33 -0500
X-AuditID: cbfee61a-b7bffae000000cfc-ea-4ec9e9b489d7
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: Fix return value of fb_notifier_call_chain
Date: Mon, 21 Nov 2011 15:03:31 +0900
Message-id: <1321855411-13730-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of blocking_notifier_call_chain isn't errno value, it
is just notify return value. The ret of fb_notifier_call_chain should is
restored to error value from notify return value using
notifier_to_errno().

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/video/fb_notify.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fb_notify.c b/drivers/video/fb_notify.c
index 74c2da5..49a64a3 100644
--- a/drivers/video/fb_notify.c
+++ b/drivers/video/fb_notify.c
@@ -42,6 +42,8 @@ EXPORT_SYMBOL(fb_unregister_client);
  */
 int fb_notifier_call_chain(unsigned long val, void *v)
 {
-	return blocking_notifier_call_chain(&fb_notifier_list, val, v);
+	int ret = blocking_notifier_call_chain(&fb_notifier_list, val, v);
+
+	return notifier_to_errno(ret);
 }
 EXPORT_SYMBOL_GPL(fb_notifier_call_chain);
-- 
1.7.5.4

