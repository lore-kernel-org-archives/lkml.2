Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2AaVYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:24:52 -0500
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:57862 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab2AaVYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:24:50 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] Input: evdev - fix variable initialisation
Date: Tue, 31 Jan 2012 22:24:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Dima Zavin <dima@android.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201312224.46360.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 509f87c5f564 (evdev - do not block waiting for an event if fd
is nonblock) created a code path were it was possible to use retval
uninitialized.

This could lead to the xorg evdev input driver getting corrupt data
and refusing to work with log messages like
	AUO-Pixcir touchscreen: Read error: Success
	sg060_keys: Read error: Success
	AUO-Pixcir touchscreen: Read error: Success
	sg060_keys: Read error: Success
(for drivers auo-pixcir-ts and gpio-keys).

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
This is obviously meant as a fix for 3.3

 drivers/input/evdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 76457d5..afc166f 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -386,7 +386,7 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 	struct evdev_client *client = file->private_data;
 	struct evdev *evdev = client->evdev;
 	struct input_event event;
-	int retval;
+	int retval = 0;
 
 	if (count < input_event_size())
 		return -EINVAL;
-- 
1.7.2.3
