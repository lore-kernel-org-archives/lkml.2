Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1E3H1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:27:20 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:49770 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1E3H1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=R1iZg3uuxxpLChVqgW/wNsliKPfM5wrIvOj0zgqLcd67CFtjVcNYkJrBrfU88j2spp
         Rp3TGDquZDNJfhMdLuRvtIpx56PFtwor33YyRl2CUbkrEiQO7Tm1fCSxWmuFGses3wR5
         yNH2J1PIsR7j3c76KWESJG7ZePq51hzsBiuuw=
From: Connor Hansen <cmdkhh@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Borislav Petkov <bp@alien8.de>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Connor Hansen <cmdkhh@gmail.com>
Subject: [PATCH 2/2] ide-cd: Fix another signedness warning
Date: Mon, 30 May 2011 00:26:58 -0700
Message-Id: <1306740418-565-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the legit warnings 'make W=3 drivers/ide/ide-cd.o generates is

drivers/ide/ide-cd.c: In function ide_cd_queue_pc:
drivers/ide/ide-cd.c:451:3: warning: conversion to unsigned int from
      int may change the sign of the result

timeout is passed as an int, but is declared as an unsigned int in
struct request in include/linux/blkdev.h

Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 drivers/ide/ide-cd.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index c1de54a..f509db5 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -422,7 +422,7 @@ static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct ide_cmd *cmd)
 
 int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		    int write, void *buffer, unsigned *bufflen,
-		    struct request_sense *sense, int timeout,
+		    struct request_sense *sense, unsigned int timeout,
 		    unsigned int cmd_flags)
 {
 	struct cdrom_info *info = drive->driver_data;
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 1efc936..24292ee 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -101,7 +101,7 @@ void ide_cd_log_error(const char *, struct request *, struct request_sense *);
 
 /* ide-cd.c functions used by ide-cd_ioctl.c */
 int ide_cd_queue_pc(ide_drive_t *, const unsigned char *, int, void *,
-		    unsigned *, struct request_sense *, int, unsigned int);
+		    unsigned *, struct request_sense *, unsigned int, unsigned int);
 int ide_cd_read_toc(ide_drive_t *, struct request_sense *);
 int ide_cdrom_get_capabilities(ide_drive_t *, u8 *);
 void ide_cdrom_update_speed(ide_drive_t *, u8 *);
-- 
1.7.4.4

