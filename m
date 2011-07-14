Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1GNFIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 01:08:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47794 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1GNFH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 01:07:59 -0400
Subject: [PATCH] HID: ACRUX - add missing hid_hw_stop() in ax_probe() error
 path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        Sergei Kolzun <x0r@dv-life.ru>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 13:07:51 +0800
Message-ID: <1310620071.2721.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid_hw_stop() must be called in ax_probe() error path if hid_hw_start()
was successful.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hid/hid-axff.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-axff.c b/drivers/hid/hid-axff.c
index b455428..1215141 100644
--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -154,6 +154,7 @@ static int ax_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	error = hid_hw_open(hdev);
 	if (error) {
 		dev_err(&hdev->dev, "hw open failed\n");
+		hid_hw_stop(hdev);
 		return error;
 	}
 
-- 
1.7.4.1



