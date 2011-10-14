Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab1JNV7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:59:47 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60876 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab1JNV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/11] drbd: Fix the maximum accepted minor device number
Date: Fri, 14 Oct 2011 23:57:46 +0200
Message-Id: <1318629472-11110-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The maximum minor device number allowed by the kernel is (1<<20 - 1).  Reject
device numbers higher than that to earlier catch possible errors.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_limits.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 9b76984..d3ec9cc 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -137,7 +137,7 @@
 #define DRBD_AL_EXTENTS_SCALE '1'
 
 #define DRBD_MINOR_NUMBER_MIN  -1
-#define DRBD_MINOR_NUMBER_MAX  (1<<30)
+#define DRBD_MINOR_NUMBER_MAX  ((1 << 20) - 1)
 #define DRBD_MINOR_NUMBER_DEF  -1
 #define DRBD_MINOR_NUMBER_SCALE '1'
 
-- 
1.7.4.1

