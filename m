Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032876Ab2I1UbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:31:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032852Ab2I1UbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:31:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Radek Masin <radek@masin.eu>, Ezequiel Garcia <elezegarcia@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 178/218] media: cx25821: Remove bad strcpy to read-only char*
Date: Fri, 28 Sep 2012 13:16:35 -0700
Message-Id: <20120928201521.946482409@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezequiel Garcia <elezegarcia@gmail.com>

commit c854d8883fec59332f0662917f8c94dcfb1c405d upstream.

The strcpy was being used to set the name of the board.
This was both wrong and redundant,
since the destination char* was read-only and
the name is set statically at compile time.

The type of the name field is changed to const char*
to prevent future errors.

Reported-by: Radek Masin <radek@masin.eu>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/cx25821/cx25821-core.c |    3 ---
 drivers/media/video/cx25821/cx25821.h      |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/media/video/cx25821/cx25821-core.c
+++ b/drivers/media/video/cx25821/cx25821-core.c
@@ -912,9 +912,6 @@ static int cx25821_dev_setup(struct cx25
 	list_add_tail(&dev->devlist, &cx25821_devlist);
 	mutex_unlock(&cx25821_devlist_mutex);
 
-	strcpy(cx25821_boards[UNKNOWN_BOARD].name, "unknown");
-	strcpy(cx25821_boards[CX25821_BOARD].name, "cx25821");
-
 	if (dev->pci->device != 0x8210) {
 		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
 			__func__, dev->pci->device);
--- a/drivers/media/video/cx25821/cx25821.h
+++ b/drivers/media/video/cx25821/cx25821.h
@@ -187,7 +187,7 @@ enum port {
 };
 
 struct cx25821_board {
-	char *name;
+	const char *name;
 	enum port porta;
 	enum port portb;
 	enum port portc;


