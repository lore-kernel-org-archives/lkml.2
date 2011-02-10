Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1BJXnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:43:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab1BJXnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:43:18 -0500
From: tlambert@chromium.org
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Terry Lambert <tlambert@chromium.org>
Subject: [PATCH] Input: fixed EVIOCGRAB iterative grab/release.
Date: Thu, 10 Feb 2011 15:42:50 -0800
Message-Id: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Terry Lambert <tlambert@chromium.org>

Fixed order of calls in evdev_ungrab to allow iterative use of
code which grabs and releases input event devices.

Signed-off-by: Terry Lambert <tlambert@chromium.org>
---
 drivers/input/evdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index c8471a2..0bac8da 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -160,9 +160,9 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
 	if (evdev->grab != client)
 		return  -EINVAL;
 
+	input_release_device(&evdev->handle);
 	rcu_assign_pointer(evdev->grab, NULL);
 	synchronize_rcu();
-	input_release_device(&evdev->handle);
 
 	return 0;
 }
-- 
1.7.3.1

