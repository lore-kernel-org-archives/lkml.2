Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1EEPHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:07:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42270 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1EEPHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XRPK+rcNoXkktHFwKJfrI0tYz+mfSTiOTgENRh+WUAeLKW1dam4KZC7Qeew36ive5E
         jUmznvKdz1ZqiuCEzh2Wiq3PTF4nYyfOhjSIFscPI7rEdLdFpwJFpoAq1R18fuItyutl
         bblHVnXMRJkbXcmNqTEdggGCr8WMiNkWjpZ+g=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: giometti@linux.it, akpm@linux-foundation.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] C2port:remove the wrong and never used macros in c2port.h
Date: Thu,  5 May 2011 23:07:13 +0800
Message-Id: <1304608033-5035-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

The macro to_class_dev used the deprecated structure class_device,
and the c2port_device has no member named class in the definition
of the macro to_c2port_device.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 include/linux/c2port.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/c2port.h b/include/linux/c2port.h
index 2a5cd86..a2f7d74 100644
--- a/include/linux/c2port.h
+++ b/include/linux/c2port.h
@@ -60,9 +60,6 @@ struct c2port_ops {
  * Exported functions
  */
 
-#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
-#define to_c2port_device(obj) container_of((obj), struct c2port_device, class)
-
 extern struct c2port_device *c2port_device_register(char *name,
 					struct c2port_ops *ops, void *devdata);
 extern void c2port_device_unregister(struct c2port_device *dev);
-- 
1.7.4.1

