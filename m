Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090Ab1GOGUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:20:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36036 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab1GOGUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:20:50 -0400
Subject: [PATCH 07/16] SCSI: sym53c416: remove Scsi_Cmnd
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave@gnu.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 15 Jul 2011 02:20:03 -0400
Message-ID: <1310710803.3184.58.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/sym53c416.c |    6 +++---
 drivers/scsi/sym53c416.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 012c86e..d37f985 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -225,7 +225,7 @@ static host hosts[MAXHOSTS] = {
 
 static int host_index = 0;
 static char info[120];
-static Scsi_Cmnd *current_command = NULL;
+static struct scsi_cmnd *current_command = NULL;
 static int fastpio = 1;
 
 static int probeaddrs[] = {0x200, 0x220, 0x240, 0};
@@ -734,7 +734,7 @@ const char *sym53c416_info(struct Scsi_Host *SChost)
 	return info;
 }
 
-static int sym53c416_queuecommand_lck(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+static int sym53c416_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	int base;
 	unsigned long flags = 0;
@@ -763,7 +763,7 @@ static int sym53c416_queuecommand_lck(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *
 
 DEF_SCSI_QCMD(sym53c416_queuecommand)
 
-static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
+static int sym53c416_host_reset(struct scsi_cmnd *SCpnt)
 {
 	int base;
 	int scsi_id = -1;	
diff --git a/drivers/scsi/sym53c416.h b/drivers/scsi/sym53c416.h
index 387de5d..d4adda0 100644
--- a/drivers/scsi/sym53c416.h
+++ b/drivers/scsi/sym53c416.h
@@ -26,7 +26,7 @@ static int sym53c416_detect(struct scsi_host_template *);
 static const char *sym53c416_info(struct Scsi_Host *);
 static int sym53c416_release(struct Scsi_Host *);
 static int sym53c416_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
-static int sym53c416_host_reset(Scsi_Cmnd *);
+static int sym53c416_host_reset(struct scsi_cmnd *);
 static int sym53c416_bios_param(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 static void sym53c416_setup(char *str, int *ints);
-- 
1.7.4.1





