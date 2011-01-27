Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1A0DZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:25:23 -0500
Received: from core.signal11.us ([64.251.29.136]:58534 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab1A0DZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:25:21 -0500
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 1/1] hidraw: Replace Confusing += Operator with =
Date: Wed, 26 Jan 2011 22:25:18 -0500
Message-Id: <1296098718-6964-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jan 26 22:25:20 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d40e5a0281781610424483
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting of the return value of hidraw_read() uses the += operator when
= is more appropriate.  There is no case where ret can be anything
other than zero when the assignment is made, making = equivalent to
+= and much more clear.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/hid/hidraw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 468e87b..66fbcba 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -91,7 +91,7 @@ static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count,
 			ret = -EFAULT;
 			goto out;
 		}
-		ret += len;
+		ret = len;
 
 		kfree(list->buffer[list->tail].value);
 		list->tail = (list->tail + 1) & (HIDRAW_BUFFER_SIZE - 1);
-- 
1.7.0.4


