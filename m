Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1JMKcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:32:23 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58081 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1JMKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/10] drbd: allow ping-timeout of up to 30 seconds
Date: Thu, 13 Oct 2011 12:32:07 +0200
Message-Id: <1318501936-11689-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
References: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Allow up to 300 centi-seconds to be configured for the "ping timeout".
There may be setups where heavy congestion, huge buffers, and asymmetric
bandwidth limitations may need a "huge" ping-timeout as work-around
for "spurious connection loss" problems.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_limits.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index dd8b8bf..f74334d 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -62,7 +62,7 @@
 
  /* timeout for the ping packets.*/
 #define DRBD_PING_TIMEO_MIN  1
-#define DRBD_PING_TIMEO_MAX  100
+#define DRBD_PING_TIMEO_MAX  300
 #define DRBD_PING_TIMEO_DEF  5
 
   /* max number of write requests between write barriers */
-- 
1.7.4.1

