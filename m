Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1FUWzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:55:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39301 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab1FUWzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:55:13 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH 3/3] light sensor: Fix a panic in the tsl2563 driver.
Date: Tue, 21 Jun 2011 15:54:57 -0700
Message-Id: <1308696897-25161-3-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1308696897-25161-1-git-send-email-bfreed@chromium.org>
References: <1308696897-25161-1-git-send-email-bfreed@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the required read/write_raw functions to the tsl2563_info_no_irq data
structure.  This structure is used insted of tsl2563_info when the I2C client
has no IRQ.
The absence of these functions causes a panic when reading or writing the
created sysfs files.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/tsl2563.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index d9be19c..bca99f1 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -713,6 +713,8 @@ static struct i2c_driver tsl2563_i2c_driver;
 
 static const struct iio_info tsl2563_info_no_irq = {
 	.driver_module = THIS_MODULE,
+	.read_raw = &tsl2563_read_raw,
+	.write_raw = &tsl2563_write_raw,
 };
 
 static const struct iio_info tsl2563_info = {
-- 
1.7.3.1

