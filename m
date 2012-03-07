Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab2CGChQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:37:16 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64449 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2CGChM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:37:12 -0500
From: Zhengwang Ruan <ruan.zhengwang@gmail.com>
To: gregkh@linuxfoundation.org, arve@android.com, chris+android@zenthought.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 v2] Staging:android: Change type for binder_debug_no_lock switch to bool
Date: Wed,  7 Mar 2012 10:36:57 +0800
Message-Id: <1331087818-9942-1-git-send-email-ruan.zhengwang@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC warns that module_param_named() indirectly returns a bool type value
which is different from 'int' type binder_debug_no_lock declared. Change
it to bool because it is a internal switch for debugging.

Signed-off-by: Zhengwang Ruan <ruan.zhengwang@gmail.com>
---
v2: added a subsystem prefix to the subject
---
 drivers/staging/android/binder.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index f0b7e66..4350425 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -103,7 +103,7 @@ static uint32_t binder_debug_mask = BINDER_DEBUG_USER_ERROR |
 	BINDER_DEBUG_FAILED_TRANSACTION | BINDER_DEBUG_DEAD_TRANSACTION;
 module_param_named(debug_mask, binder_debug_mask, uint, S_IWUSR | S_IRUGO);
 
-static int binder_debug_no_lock;
+static bool binder_debug_no_lock;
 module_param_named(proc_no_lock, binder_debug_no_lock, bool, S_IWUSR | S_IRUGO);
 
 static DECLARE_WAIT_QUEUE_HEAD(binder_user_error_wait);
-- 
1.6.0.4

