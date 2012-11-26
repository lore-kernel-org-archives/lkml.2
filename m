Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2KZU1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:27:13 -0500
Received: from mail.ispras.ru ([83.149.199.43]:57449 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab2KZU1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:27:11 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] uwb: fix uwb_dev_unlock() missed at an error path in uwb_rc_cmd_async()
Date: Tue, 27 Nov 2012 00:26:46 +0400
Message-Id: <1353961606-2090-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is the only path in uwb_rc_cmd_async() where rc->uwb_dev is left unlocked.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/uwb/reset.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/uwb/reset.c b/drivers/uwb/reset.c
index 7032285..8b47c9c 100644
--- a/drivers/uwb/reset.c
+++ b/drivers/uwb/reset.c
@@ -97,6 +97,7 @@ int uwb_rc_cmd_async(struct uwb_rc *rc, const char *cmd_name,
 	neh = uwb_rc_neh_add(rc, cmd, expected_type, expected_event, cb, arg);
 	if (IS_ERR(neh)) {
 		result = PTR_ERR(neh);
+		uwb_dev_unlock(&rc->uwb_dev);
 		goto out;
 	}
 
-- 
1.7.9.5

