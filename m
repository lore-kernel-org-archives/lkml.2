Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332Ab1LPSHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:07:34 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60441 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab1LPSHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:07:13 -0500
From: Dima Zavin <dima@android.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dima Zavin <dima@android.com>, Jeff Brown <jeffbrown@android.com>
Subject: [PATCH 2/3] input: evdev: if no events and non-block, return EAGAIN not 0
Date: Fri, 16 Dec 2011 10:07:05 -0800
Message-Id: <1324058826-12891-2-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324058826-12891-1-git-send-email-dima@android.com>
References: <1324058826-12891-1-git-send-email-dima@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jeff Brown <jeffbrown@android.com>
Signed-off-by: Dima Zavin <dima@android.com>
---
 drivers/input/evdev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 03344b3..2e563af 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -412,6 +412,8 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 		retval += input_event_size();
 	}
 
+	if (retval == 0 && file->f_flags & O_NONBLOCK)
+		retval = -EAGAIN;
 	return retval;
 }
 
-- 
1.7.3.1

