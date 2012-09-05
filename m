Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab2IEPVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:21:32 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:42890 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2IEPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:21:28 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuVPAKNtR1BV5qoUPGdsb2JhbABFhT6FAbBjGQEBAQEeGQ0ngn0TAQ8YEXEKGhOIEbp8FIsGDIZtA5tHjRGBVgE
X-IronPort-AV: E=Sophos;i="4.80,375,1344204000"; 
   d="scan'208";a="109577978"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] HID: Allow more fields in the hid report
Date: Wed,  5 Sep 2012 17:27:36 +0200
Message-Id: <1346858857-281-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some recent hardware define more than 128 fields in the report
descriptor. Increase the limit to 256. This adds another kilobyte of
memory per report.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Jiri,

The Flatfrog panel (next patch) reports 188 fields, so 256 seems like
a fair number. I am not overly thrilled about this patch, but the
alternative looks like a major change. At least it will be easy to
backport. :-)

Thanks,
Henrik

 include/linux/hid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index f37da28..7e1f37d 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -414,7 +414,7 @@ struct hid_field {
 	__u16 dpad;			/* dpad input code */
 };
 
-#define HID_MAX_FIELDS 128
+#define HID_MAX_FIELDS 256
 
 struct hid_report {
 	struct list_head list;
-- 
1.7.12

