Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562Ab1ESTlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:41:46 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:37349 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934493Ab1ESTlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:41:44 -0400
From: Armando Visconti <armando.visconti@st.com>
To: <jkosina@suse.cz>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Armando Visconti <armando.visconti@st.com>
Subject: [PATCH] HID: Fixed a crash in hid_report_raw_event() function.
Date: Thu, 19 May 2011 21:41:22 +0200
Message-ID: <1305834082-14888-1-git-send-email-armando.visconti@st.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using a Data Modul EasyTouch USB multitouch controller,
which is issuing a hid report with a size equals to 0. The rsize
value gets set to 536870912 and Linux is crashing in the memset
because the value is too big.

Signed-off-by: Armando Visconti <armando.visconti@st.com>
---
 drivers/hid/hid-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c3d6626..3e972e3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1045,6 +1045,9 @@ void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 
 	rsize = ((report->size - 1) >> 3) + 1;
 
+	if (rsize > HID_MAX_BUFFER_SIZE)
+		rsize = HID_MAX_BUFFER_SIZE;
+
 	if (csize < rsize) {
 		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
 				csize, rsize);
-- 
1.7.4

