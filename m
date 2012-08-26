Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2HZMy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 08:54:28 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:45981 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab2HZMyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 08:54:22 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApRZALMbOlBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG7SRSSBQObQI0P
X-IronPort-AV: E=Sophos;i="4.77,830,1336341600"; 
   d="scan'208";a="180869364"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 19/20] HID: hid-debug: Show rdesc for unclaimed devices
Date: Sun, 26 Aug 2012 14:57:37 +0200
Message-Id: <1345985858-445-20-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345985858-445-1-git-send-email-rydberg@euromail.se>
References: <1345985858-445-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit a7197c2e, the raw report descriptor is available also for
unclaimed devices. This patch makes it show in the rdesc debugfs node.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-debug.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 01dd9a7..933fff0 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -911,15 +911,21 @@ static void hid_dump_input_mapping(struct hid_device *hid, struct seq_file *f)
 
 }
 
-
 static int hid_debug_rdesc_show(struct seq_file *f, void *p)
 {
 	struct hid_device *hdev = f->private;
+	const __u8 *rdesc = hdev->rdesc;
+	unsigned rsize = hdev->rsize;
 	int i;
 
+	if (!rdesc) {
+		rdesc = hdev->dev_rdesc;
+		rsize = hdev->dev_rsize;
+	}
+
 	/* dump HID report descriptor */
-	for (i = 0; i < hdev->rsize; i++)
-		seq_printf(f, "%02x ", hdev->rdesc[i]);
+	for (i = 0; i < rsize; i++)
+		seq_printf(f, "%02x ", rdesc[i]);
 	seq_printf(f, "\n\n");
 
 	/* dump parsed data and input mappings */
-- 
1.7.12

