Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2KCJs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:48:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37117 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2KCJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:48:27 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/2] firmware loader: document firmware cache mechanism
Date: Sat,  3 Nov 2012 17:48:16 +0800
Message-Id: <1351936096-13324-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch documents the firmware cache mechanism so that
users of request_firmware() know that it can be called
safely inside device's suspend and resume callback, and
the device's firmware needn't be cached any more by individual
driver itself to deal with firmware loss during system resume.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 Documentation/firmware_class/README |    7 +++++++
 drivers/base/firmware_class.c       |    3 +++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index e9fce78..43fada9 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -119,3 +119,10 @@
    on the setup, so I think that the choice on what firmware to make
    persistent should be left to userspace.
 
+ about firmware cache:
+ --------------------
+ After firmware cache mechanism is introduced during system sleep,
+ request_firmware can be called safely inside device's suspend and
+ resume callback, and callers need't cache the firmware by
+ themselves any more for dealing with firmware loss during system
+ resume.
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 2067514..15f2822 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -978,6 +978,9 @@ err_put_dev:
  *      firmware image for this or any other device.
  *
  *	Caller must hold the reference count of @device.
+ *
+ *	The function can be called safely inside device's suspend and
+ *	resume callback.
  **/
 int
 request_firmware(const struct firmware **firmware_p, const char *name,
-- 
1.7.9.5

