Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2GXQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:59:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51827 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab2GXQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:59:23 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+Uk-5hKMnwi4FO5CBSgH6+QNsz1n8faN5rQxXvgSWVGNg@mail.gmail.com>
References: <CALF0-+UJamw8fiB-rcX0WdYRAFnAdYxPoPQtMzG=5E2T8wz2yw@mail.gmail.com>
	<CALF0-+Uk-5hKMnwi4FO5CBSgH6+QNsz1n8faN5rQxXvgSWVGNg@mail.gmail.com>
Date: Tue, 24 Jul 2012 13:59:22 -0300
Message-ID: <CALF0-+Unvjo_SZom-x2b7X0kLg90GHeiQhXpQPh58fA=Dj5gpQ@mail.gmail.com>
Subject: [PATCH for stable] cx25821: Remove bad strcpy to read-only char*
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: gregkh <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch is already in Linus' tree and I really think it should go into stable
as well. You will find this bug in every kernel from the moment cx25821 went
out of staging.

I just read Documentation/stable_kernel_rules.txt, so I guess it was enough
to add a tag "Cc: stable@vger.kernel.org" in the patch (right?).
Now I know it :-)

If I'm doing anything wrong, just yell at me.

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
