Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2LDP26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:28:58 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50038 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab2LDP2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:28:36 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] HID: i2c-hid: also call i2c_hid_free_buffers in i2c_hid_remove
Date: Tue,  4 Dec 2012 16:27:54 +0100
Message-Id: <1354634875-5182-14-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case where the hid driver in charge of handling the hid part
of the device (hid-generic for instance) fails at probe, neither
i2c_hid_start nor i2c_hid_stop are called.
Thus, the buffers allocated in i2c_hid_probe are never freed.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index bea4b13..62988f1 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -891,6 +891,9 @@ static int __devexit i2c_hid_remove(struct i2c_client *client)
 
 	free_irq(client->irq, ihid);
 
+	if (ihid->bufsize)
+		i2c_hid_free_buffers(ihid);
+
 	kfree(ihid);
 
 	return 0;
-- 
1.8.0.1

