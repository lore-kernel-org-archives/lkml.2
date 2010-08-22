Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab0HVXoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 19:44:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59674 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0HVXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 19:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Q75UaHn3yz4yQIxjIRr2URCRxoh5184TqPMR4QEbly4xYKozZh5+k11Y+UZZOdyZBV
         VcQabS3SdYXjRDzdDwc/dU9kPpRz+/YqaPAqGHJj9nF3rm2wjgfCIxxkeRFyaObORDPe
         DRWA3MjK+GpaWa9Q9BeCaVZszX8hEskx7L+oE=
From: Nikitas Angelinas <nikitasangelinas@googlemail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, 21cnbao@gmail.com,
        tj@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Nikitas Angelinas <nikitasangelinas@googlemail.com>
Subject: [PATCH] kernel: time: use ARRAY_SIZE macro in timecompare.c
Date: Mon, 23 Aug 2010 00:43:49 +0100
Message-Id: <1282520629-6542-1-git-send-email-nikitasangelinas@googlemail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof(buffer)/sizeof(buffer[0]) with ARRAY_SIZE(buffer) in
kernel/time/timecompare.c

Signed-off-by: Nikitas Angelinas <nikitasangelinas@googlemail.com>
---
 kernel/time/timecompare.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
index ac38fbb..a9ae369 100644
--- a/kernel/time/timecompare.c
+++ b/kernel/time/timecompare.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/math64.h>
+#include <linux/kernel.h>
 
 /*
  * fixed point arithmetic scale factor for skew
@@ -57,11 +58,11 @@ int timecompare_offset(struct timecompare *sync,
 	int index;
 	int num_samples = sync->num_samples;
 
-	if (num_samples > sizeof(buffer)/sizeof(buffer[0])) {
+	if (num_samples > ARRAY_SIZE(buffer)) {
 		samples = kmalloc(sizeof(*samples) * num_samples, GFP_ATOMIC);
 		if (!samples) {
 			samples = buffer;
-			num_samples = sizeof(buffer)/sizeof(buffer[0]);
+			num_samples = ARRAY_SIZE(buffer);
 		}
 	} else {
 		samples = buffer;
-- 
1.7.1.1

