Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1I0M0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:26:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50234 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1I0M0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:26:22 -0400
From: Amit Nagal <helloin.amit@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Nagal <helloin.amit@gmail.com>
Subject: [PATCH 1/1] HID: hidraw: open count should not increase if error
Date: Tue, 27 Sep 2011 13:41:58 -0400
Message-Id: <1317145318-19656-1-git-send-email-helloin.amit@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hidraw_open, if hid_hw_power returns with error,
hidraw device open count should not increase.

Signed-off-by: Amit Nagal <helloin.amit@gmail.com>
---
 drivers/hid/hidraw.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index c841a8e..09bbcc9 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -271,8 +271,10 @@ static int hidraw_open(struct inode *inode, struct file *file)
 	dev = hidraw_table[minor];
 	if (!dev->open++) {
 		err = hid_hw_power(dev->hid, PM_HINT_FULLON);
-		if (err < 0)
+		if (err < 0) {
+			dev->open--;
 			goto out_unlock;
+		}
 
 		err = hid_hw_open(dev->hid);
 		if (err < 0) {
-- 
1.7.7-rc0

