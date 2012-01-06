Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030336Ab2AFLDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:03:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37700 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030241Ab2AFLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:03:39 -0500
From: Che-Liang Chiou <clchiou@chromium.org>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 2/2] Input: serio_raw - return error code instead of written on error
Date: Fri,  6 Jan 2012 19:03:15 +0800
Message-Id: <1325847795-30486-2-git-send-email-clchiou@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325847795-30486-1-git-send-email-clchiou@chromium.org>
References: <1325847795-30486-1-git-send-email-clchiou@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if an error occurs and error code is set, serio_raw_write() returns
the amount of bytes written anyway.

If this behavior is actually desirable, serio_raw_write() should not
even bother to set the error code because it is not intended to be
returned to the caller.

Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
---
 drivers/input/serio/serio_raw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index a935c38..32416f7 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -224,7 +224,7 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
 
 out:
 	mutex_unlock(&serio_raw_mutex);
-	return written;
+	return retval ?: written;
 }
 
 static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
-- 
1.7.3.1

