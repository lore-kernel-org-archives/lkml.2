Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0KJMsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:48:30 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12579 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0KJMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:48:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6162"; a="61428808"
From: Trilok Soni <tsoni@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Trilok Soni <tsoni@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [RFC v1 PATCH 1/6] matrix_keypad: Increase the max limit of rows and columns
Date: Wed, 10 Nov 2010 18:17:56 +0530
Message-Id: <1289393281-4459-2-git-send-email-tsoni@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some keyboard controller have support for more than
16 columns and rows.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
---
 include/linux/input/matrix_keypad.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
index 80352ad..d80845e 100644
--- a/include/linux/input/matrix_keypad.h
+++ b/include/linux/input/matrix_keypad.h
@@ -4,11 +4,11 @@
 #include <linux/types.h>
 #include <linux/input.h>
 
-#define MATRIX_MAX_ROWS		16
-#define MATRIX_MAX_COLS		16
+#define MATRIX_MAX_ROWS		18
+#define MATRIX_MAX_COLS		18
 
-#define KEY(row, col, val)	((((row) & (MATRIX_MAX_ROWS - 1)) << 24) |\
-				 (((col) & (MATRIX_MAX_COLS - 1)) << 16) |\
+#define KEY(row, col, val)	((((row) % (MATRIX_MAX_ROWS)) << 24) |\
+				 (((col) % (MATRIX_MAX_COLS)) << 16) |\
 				 (val & 0xffff))
 
 #define KEY_ROW(k)		(((k) >> 24) & 0xff)
-- 
1.7.0.2

