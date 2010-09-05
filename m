Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0IEPd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 11:33:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51220 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0IEPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 11:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YF5b0pqE7YPr365EJINQ7xkIfArF6Elc+lfWgyecVaDt7j80lvg1JnO2iCVRC45gJC
         wA3UljopMWva4dy1un5Pmtk0SwTwTuz1hqZ3dZYiUsgl0fvh7ZYQsIH6TIoNUkPjQjUq
         ez81ODhL8k//CIQfreKc4X5HD6wMVKqB1Sy1I=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: eric.y.miao@gmail.com, grinberg@compulab.co.il,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        haojian.zhuang@marvell.com
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH] ARM: pxa27x_keypad: added a comment to explain clear_wakeup_event callback
Date: Sun,  5 Sep 2010 11:33:10 -0400
Message-Id: <1283700790-3558-1-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/plat-pxa/include/plat/pxa27x_keypad.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
index 73dacda..abcc36e 100644
--- a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
+++ b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
@@ -25,6 +25,13 @@
  *
  * 4. matrix key and direct key will use the same debounce_interval by
  *    default, which should be sufficient in most cases
+ *
+ * pxa168 keypad platform specific parameter
+ *
+ * NOTE:
+ * clear_wakeup_event callback is a workaround required to clear the
+ * keypad interrupt. The keypad wake must be cleared in addition to
+ * reading the MI/DI bits in the KPC register.
  */
 struct pxa27x_keypad_platform_data {
 
@@ -52,6 +59,8 @@ struct pxa27x_keypad_platform_data {
 
 	/* key debounce interval */
 	unsigned int	debounce_interval;
+
+	/* clear wakeup event requirement for pxa168 */
 	void		(*clear_wakeup_event)(void);
 };
 
-- 
1.7.0.4

