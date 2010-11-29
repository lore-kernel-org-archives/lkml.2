Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0K2HoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 02:44:20 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:56916 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755150Ab0K2HoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 02:44:19 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/7] hid: egalax: Use kzalloc
Date: Mon, 29 Nov 2010 08:43:26 +0100
Message-Id: <1291016612-25102-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PMyOp-0000TL-Bg.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PMyOp-0000TL-Bg 5d56932151afa3d02e31ccaae8250e02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid unnecessary explicit initialization, allocate zeroed memory.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-egalax.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index 54b017a..5a1b52e 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -221,7 +221,7 @@ static int egalax_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct egalax_data *td;
 	struct hid_report *report;
 
-	td = kmalloc(sizeof(struct egalax_data), GFP_KERNEL);
+	td = kzalloc(sizeof(struct egalax_data), GFP_KERNEL);
 	if (!td) {
 		dev_err(&hdev->dev, "cannot allocate eGalax data\n");
 		return -ENOMEM;
-- 
1.7.1

