Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab0JZKTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:19:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60802 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759497Ab0JZKSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:25 -0400
From: Julia Lawall <julia@diku.dk>
To: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] drivers/scsi/be2iscsi/be_main.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:42 +0200
Message-Id: <1288088743-3725-14-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.  Initialize the
pwrb_handle field instead of initializing the psgl_handle field twice.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and has not been tested.

 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 75a85aa..9e1878f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3794,7 +3794,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 
 	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs->iscsi_hdr;
 	task->hdr_max = sizeof(struct be_cmd_bhs);
-	io_task->psgl_handle = NULL;
+	io_task->pwrb_handle = NULL;
 	io_task->psgl_handle = NULL;
 
 	if (task->sc) {

