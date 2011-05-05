Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1EEM37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:29:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39991 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1EEM36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gO+DqsWqrfonZXu3k2PMiKUj5R7RbsTQHtV7AKgy1IeWzZ00hkfIHxBW2N1luWAS4A
         cRIo9IOeBBG2+3wUsKufVojG4p198qszaNfeWP9VO0gQKUxRaRs7+5lonIpUzFx3Yag3
         9oS7pNJw7vVPQ4kKbOGObyYJBk/wb5DQ/vH7U=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] C2port:Fix deprecated exported interfaces c2port.h
Date: Thu,  5 May 2011 20:29:09 +0800
Message-Id: <1304598549-3561-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Change to_class_dev to to_device since the struct class_device had
merged to struct device.
Fix the to_c2port_device interface since the struct c2port_device
has no member named class.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 include/linux/c2port.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/c2port.h b/include/linux/c2port.h
index 2a5cd86..7e6bd33 100644
--- a/include/linux/c2port.h
+++ b/include/linux/c2port.h
@@ -60,8 +60,8 @@ struct c2port_ops {
  * Exported functions
  */
 
-#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
-#define to_c2port_device(obj) container_of((obj), struct c2port_device, class)
+#define to_device(obj) container_of(obj, struct device, kobj)
+#define to_c2port_device(obj) container_of(obj, struct c2port_device, dev.kobj)
 
 extern struct c2port_device *c2port_device_register(char *name,
 					struct c2port_ops *ops, void *devdata);
-- 
1.7.4.1

