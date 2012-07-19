Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab2GSNoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:44:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45724 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2GSNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:44:20 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+UJamw8fiB-rcX0WdYRAFnAdYxPoPQtMzG=5E2T8wz2yw@mail.gmail.com>
References: <CALF0-+UJamw8fiB-rcX0WdYRAFnAdYxPoPQtMzG=5E2T8wz2yw@mail.gmail.com>
Date: Thu, 19 Jul 2012 10:44:19 -0300
Message-ID: <CALF0-+Uk-5hKMnwi4FO5CBSgH6+QNsz1n8faN5rQxXvgSWVGNg@mail.gmail.com>
Subject: [PATCH for v3.5] cx25821: Remove bad strcpy to read-only char*
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-media <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I'm sending the attached patch directly to you for inclusion in 3.5 as
without it the cx25821 driver will panic on probe.

It looks like this bug has been around since cx25821 was first mainlined,
so it could make sense to consider its inclusion in stable also.

Since Mauro is still on vacation, I'm sending directly to you so
this can be merged for 3.5 before it is released.

Thanks,
Ezequiel.

>From 1859521e76226687e79e1452b040fd3e02c469d8 Mon Sep 17 00:00:00 2001
From: Ezequiel Garcia <elezegarcia@gmail.com>
Date: Wed, 18 Jul 2012 10:05:26 -0300
Subject: [PATCH] cx25821: Remove bad strcpy to read-only char*

The strcpy was being used to set the name of the board.
Since the destination char* was read-only and the name
is set statically at compile time; this was both
wrong and redundant.

The type of char* is changed to const char* to prevent
future errors.

Reported-by: Radek Masin <radek@masin.eu>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx25821/cx25821-core.c |    3 ---
 drivers/media/video/cx25821/cx25821.h      |    2 +-
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-core.c
b/drivers/media/video/cx25821/cx25821-core.c
index 7930ca5..235bf7d 100644
--- a/drivers/media/video/cx25821/cx25821-core.c
+++ b/drivers/media/video/cx25821/cx25821-core.c
@@ -912,9 +912,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
        list_add_tail(&dev->devlist, &cx25821_devlist);
        mutex_unlock(&cx25821_devlist_mutex);

-       strcpy(cx25821_boards[UNKNOWN_BOARD].name, "unknown");
-       strcpy(cx25821_boards[CX25821_BOARD].name, "cx25821");
-
        if (dev->pci->device != 0x8210) {
                pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
                        __func__, dev->pci->device);
diff --git a/drivers/media/video/cx25821/cx25821.h
b/drivers/media/video/cx25821/cx25821.h
index b9aa801..029f293 100644
--- a/drivers/media/video/cx25821/cx25821.h
+++ b/drivers/media/video/cx25821/cx25821.h
@@ -187,7 +187,7 @@ enum port {
 };

 struct cx25821_board {
-       char *name;
+       const char *name;
        enum port porta;
        enum port portb;
        enum port portc;
--
1.7.8.6
