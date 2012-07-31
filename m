Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab2GaEva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48889 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755731Ab2GaEvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:09 -0400
Message-Id: <20120731044314.682435444@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ezequiel Garcia <elezegarcia@gmail.com>,
        Radek Masin <radek@masin.eu>
Subject: [ 21/73] cx25821: Remove bad strcpy to read-only char*
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezequiel Garcia <elezegarcia@gmail.com>

commit 380e99fc44d79bc35af9ff1d3316ef4027ce775e upstream.

The strcpy was being used to set the name of the board.  Since the
destination char* was read-only and the name is set statically at
compile time; this was both wrong and redundant.

The type of char* is changed to const char* to prevent future errors.

Reported-by: Radek Masin <radek@masin.eu>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
[ Taking directly due to vacations   - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/cx25821/cx25821-core.c |    3 ---
 drivers/media/video/cx25821/cx25821.h      |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-core.c b/drivers/media/video/cx25821/cx25821-core.c
index 83c1aa6..f11f6f0 100644
--- a/drivers/media/video/cx25821/cx25821-core.c
+++ b/drivers/media/video/cx25821/cx25821-core.c
@@ -904,9 +904,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	list_add_tail(&dev->devlist, &cx25821_devlist);
 	mutex_unlock(&cx25821_devlist_mutex);
 
-	strcpy(cx25821_boards[UNKNOWN_BOARD].name, "unknown");
-	strcpy(cx25821_boards[CX25821_BOARD].name, "cx25821");
-
 	if (dev->pci->device != 0x8210) {
 		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
 			__func__, dev->pci->device);
diff --git a/drivers/media/video/cx25821/cx25821.h b/drivers/media/video/cx25821/cx25821.h
index b9aa801..029f293 100644
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


