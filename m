Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2EDMyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:54:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60463 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2EDMyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:54:07 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] HID: hid-multitouch: get maxcontacts also from logical_max value
Date: Fri,  4 May 2012 14:53:47 +0200
Message-Id: <1336136030-18503-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Win8 devices are required to present the feature "Maximum Contact Number".
If the current value is 0, then, the driver can get the actual supported
contact count by seeing the logical_max.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c6ffb05..e205d1e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -265,6 +265,8 @@ static void mt_feature_mapping(struct hid_device *hdev,
 	case HID_DG_CONTACTMAX:
 		td->maxcontact_report_id = field->report->id;
 		td->maxcontacts = field->value[0];
+		if (!td->maxcontacts)
+			td->maxcontacts = field->logical_maximum;
 		if (td->mtclass.maxcontacts)
 			/* check if the maxcontacts is given by the class */
 			td->maxcontacts = td->mtclass.maxcontacts;
-- 
1.7.7.6

