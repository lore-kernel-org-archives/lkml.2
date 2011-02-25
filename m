Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1BYFio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 00:38:44 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:49511 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1BYFin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 00:38:43 -0500
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Feb 2011 00:38:43 EST
From: Rafi Rubin <rafi@seas.upenn.edu>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr, trivial@kernel.org, peter.hutterer@who-t.net,
        Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 2/2] HID: ntrig mapping more firmware id bits
Date: Fri, 25 Feb 2011 00:15:32 -0500
Message-Id: <1298610932-21957-2-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298610932-21957-1-git-send-email-rafi@seas.upenn.edu>
References: <1298610932-21957-1-git-send-email-rafi@seas.upenn.edu>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-02-25_02:2011-02-25,2011-02-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---
Two new firmwares supply hints to map three more bits of the raw
firmware id code.

Confirmation, and perhaps the rest of the mapping from someone with both
the knowledge and legal rights would be appreciated.  Not that I mind
the pleasure of the puzzle being filled in slowly over time.
---
 drivers/hid/hid-ntrig.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 616f091..3ce4624 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -96,15 +96,15 @@ struct ntrig_data {
  */
 static int ntrig_version_string(unsigned char *raw, char *buf)
 {
-	__u8 a =  (raw[1] & 0x0e) >> 1;
+	__u8 a =  (raw[1] & 0x1e) >> 1;
 	__u8 b =  (raw[0] & 0x3c) >> 2;
 	__u8 c = ((raw[0] & 0x03) << 3) | ((raw[3] & 0xe0) >> 5);
 	__u8 d = ((raw[3] & 0x07) << 3) | ((raw[2] & 0xe0) >> 5);
-	__u8 e =   raw[2] & 0x07;
+	__u8 e =   raw[2] & 0x1f;
 
 	/*
 	 * As yet unmapped bits:
-	 * 0b11000000 0b11110001 0b00011000 0b00011000
+	 * 0b11000000 0b11100001 0b00000000 0b00011000
 	 */
 
 	return sprintf(buf, "%u.%u.%u.%u.%u", a, b, c, d, e);
-- 
1.7.2.3

