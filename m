Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1K3Xhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:37:46 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63606 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665Ab1K3Xhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:37:45 -0500
Date: Thu, 1 Dec 2011 01:37:33 +0200
From: "Maxin B. John" <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, paul.gortmaker@windriver.com, mikew@google.com,
        dlaurie@google.com, adurbin@google.com
Subject: [PATCH] firmware: google: fix gsmi.c build warning
Message-ID: <20111130233733.GA11577@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use min_t() macro instead of min() to fix a build warning:

  CC      drivers/firmware/google/gsmi.o
drivers/firmware/google/gsmi.c: In function ‘gsmi_get_variable’:
drivers/firmware/google/gsmi.c:348: warning: comparison of distinct
pointer types lacks a cast

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index c4e7c59..91ddf0f 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -345,7 +345,8 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
 		memcpy(&param, gsmi_dev.param_buf->start, sizeof(param));
 
 		/* The size reported is the min of all of our buffers */
-		*data_size = min(*data_size, gsmi_dev.data_buf->length);
+		*data_size = min_t(unsigned long, *data_size,
+						gsmi_dev.data_buf->length);
 		*data_size = min_t(unsigned long, *data_size, param.data_len);
 
 		/* Copy data back to return buffer. */
