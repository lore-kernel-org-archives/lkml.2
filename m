Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1AaK2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:28:36 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:33263 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab1AaK2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:28:33 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] hid-multitouch: change default mt_class
Date: Mon, 31 Jan 2011 11:28:19 +0100
Message-Id: <1296469702-3710-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296469702-3710-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1296469702-3710-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The safest quirk for a device (the one that works out of the box for
most of them) is MT_QUIRK_NOT_SEEN_MEANS_UP. Indeed, it does not
make any assumption on the device. When adding a new device, we can
easily test it against MT_CLS_DEFAULT, and then optimize it with other
quirks: that's why no device use MT_CLS_DEFAULT right now.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 07d3183..86863a3 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -104,7 +104,7 @@ static int find_slot_from_contactid(struct mt_device *td)
 
 struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
-		.quirks = MT_QUIRK_VALID_IS_INRANGE,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
 		.maxcontacts = 10 },
 	{ .name = MT_CLS_DUAL1,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
-- 
1.7.3.4

