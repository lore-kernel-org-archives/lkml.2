Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0JMN74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:59:56 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:49470 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913Ab0JMN7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:59:54 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/6] hid: egalax: Use kzalloc
Date: Wed, 13 Oct 2010 15:58:17 +0200
Message-Id: <1286978302-30034-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P61qy-0001qa-A7.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1P61qy-0001qa-A7 6a1a2e861d6b3ff95c07338a118a77ef
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

