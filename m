Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1ADGAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:00:04 -0500
Received: from core.signal11.us ([64.251.29.136]:58055 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1ADGAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:00:00 -0500
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 1/1] hidraw: Added Compatibility ioctl() for 32-bit applications.
Date: Tue,  4 Jan 2011 00:37:22 -0500
Message-Id: <1294119442-6827-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294119442-6827-1-git-send-email-alan@signal11.us>
References: <1294119442-6827-1-git-send-email-alan@signal11.us>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan  4 00:37:29 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d22b219251891616892266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the ioctl function to the compat_ioctl pointer in the file_operations struct. Before this, some ioctls would fail for 32-bit apps on 64-bit systems.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/hid/hidraw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 29495e6..57ccc5f 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -428,6 +428,9 @@ static const struct file_operations hidraw_ops = {
 	.open =         hidraw_open,
 	.release =      hidraw_release,
 	.unlocked_ioctl = hidraw_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= hidraw_ioctl,
+#endif
 };
 
 void hidraw_report_event(struct hid_device *hid, u8 *data, int len)
-- 
1.7.0.4


