Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1HFQm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 12:42:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51960 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab1HFQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 12:42:24 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, mikew@google.com, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] fimware: fix build warning
Date: Sun,  7 Aug 2011 00:39:26 +0800
Message-Id: <1312648766-19073-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  drivers/firmware/google/gsmi.c: In function 'gsmi_get_variable':
  drivers/firmware/google/gsmi.c:347: warning: comparison of distinct pointer types lacks a cast
  drivers/firmware/google/gsmi.c: At top level:
  drivers/firmware/google/gsmi.c:473: warning: initialization from incompatible pointer type

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/firmware/google/gsmi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 68810fd..711753f 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -344,7 +344,7 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
 		memcpy(&param, gsmi_dev.param_buf->start, sizeof(param));
 
 		/* The size reported is the min of all of our buffers */
-		*data_size = min(*data_size, gsmi_dev.data_buf->length);
+		*data_size = min_t(unsigned long, *data_size, gsmi_dev.data_buf->length);
 		*data_size = min_t(unsigned long, *data_size, param.data_len);
 
 		/* Copy data back to return buffer. */
@@ -420,7 +420,7 @@ static efi_status_t gsmi_get_next_variable(unsigned long *name_size,
 
 static efi_status_t gsmi_set_variable(efi_char16_t *name,
 				      efi_guid_t *vendor,
-				      unsigned long attr,
+				      u32 attr,
 				      unsigned long data_size,
 				      void *data)
 {
-- 
1.7.0.4

