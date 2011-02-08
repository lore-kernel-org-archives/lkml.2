Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1BHNlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:41:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58345 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1BHNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=RJcE34xsr4VqxJSFS6Zwm8piaCNQnp8n0gGosaNPv2C9lhqBA0I8RR4A4l4sTwh3me
         j1MVsW00HJkfq+YwF7otswfLt8JerWJomKhNc21jr9tQszD3zAjRtC8LZqc8qj58aflC
         GFP/VhpN+GDhQz+dXEfpke2LYmc6V8snrpaWo=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging: ft1000: Remove unnecessary check in write_blk_fifo().
Date: Tue,  8 Feb 2011 14:41:38 +0100
Message-Id: <1297172498-7366-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

byte_length = word_length * 4;

if (byte_length % 4) ...

word_length * 4 is always aligned at 4 bytes. Remove pointless
check.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 1797c4d..8e62242 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -644,16 +644,9 @@ static u32 write_blk_fifo(struct ft1000_device *ft1000dev, u16 **pUsFile,
 {
 	u32 Status = STATUS_SUCCESS;
 	int byte_length;
-	long aligncnt;
 
 	byte_length = word_length * 4;
 
-	if (byte_length % 4)
-		aligncnt = 4 - (byte_length % 4);
-	else
-		aligncnt = 0;
-	byte_length += aligncnt;
-
 	if (byte_length && ((byte_length % 64) == 0))
 		byte_length += 4;
 
-- 
1.7.1

