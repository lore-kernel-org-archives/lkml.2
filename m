Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0I3IYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:24:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0I3IYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:24:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/6] staging/ft1000-usb: fix unlocked_ioctl prototype
Date: Thu, 30 Sep 2010 10:24:08 +0200
Message-Id: <1285835052-11880-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285835052-11880-1-git-send-email-arnd@arndb.de>
References: <1285835052-11880-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:mwzAGD2lTgjr6kdKRLfE14HI8fB2/wNNjRjh9AkkJlw
 0fhFMH4oAR/Qez6IDL5U+75/YJqb/tIed5Cy631E5ncq8AQNNC
 lEBD9ex188OMen6nnhySffjpoMX3EJ7jiH9eNBwRJQRYbLF/GG
 OGld2pqxhifynkhS40lwwc6pcZ7fz359Yjg2+OC+ByJOVBv0jN
 1iYYT4sNRpZ+YaeCOunEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unlocked_ioctl has a "long" return type.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 89d9a58..44b037c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -51,7 +51,7 @@ extern void CardSendCommand(struct ft1000_device *ft1000dev, unsigned short *pte
 
 static int ft1000_ChOpen (struct inode *Inode, struct file *File);
 static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait);
-static int ft1000_ChIoctl(struct file *File, unsigned int Command,
+static long ft1000_ChIoctl(struct file *File, unsigned int Command,
                            unsigned long Argument);
 static int ft1000_ChRelease (struct inode *Inode, struct file *File);
 
@@ -536,7 +536,7 @@ static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static int ft1000_ChIoctl (struct file *File, unsigned int Command,
+static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                            unsigned long Argument)
 {
     struct net_device *dev;
-- 
1.7.1

