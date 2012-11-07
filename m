Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2KGQlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:41:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56378 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2KGQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:37:57 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/13] HID: hid-input: round return value of hidinput_calc_abs_res
Date: Wed,  7 Nov 2012 17:37:25 +0100
Message-Id: <1352306256-12180-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hidinput_calc_abs_res should return the closest int in the division
instead of the floor.
On a device with a logical_max of 3008 and a physical_max of 255mm,
previous implementation gave a resolution of 11 instead of 12.
With 11, user-space computes a physical size of 273.5mm and the
round_closest results gives 250.6mm.
The old implementation introduced an error of 2cm in this example.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index f5b1d57..67044f3 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -287,7 +287,7 @@ __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
 	}
 
 	/* Calculate resolution */
-	return logical_extents / physical_extents;
+	return DIV_ROUND_CLOSEST(logical_extents, physical_extents);
 }
 EXPORT_SYMBOL_GPL(hidinput_calc_abs_res);
 
-- 
1.7.11.7

