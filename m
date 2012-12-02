Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2LBCr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 21:47:29 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48386 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2LBCr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 21:47:27 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        JBottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: [PATCH 2/6] scsi: bfa: remove useless calls to memset().
Date: Sun,  2 Dec 2012 03:40:18 +0100
Message-Id: <1354416022-20189-3-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
References: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These calls are followed by calls to memcpy() on the same memory area, so they
can safely be removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/scsi/bfa/bfa_ioc.c  |    1 -
 drivers/scsi/bfa/bfad_bsg.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 0116c10..dd2a2ef 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2517,7 +2517,6 @@ bfa_ioc_get_type(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num)
 {
-	memset((void *)serial_num, 0, BFA_ADAPTER_SERIAL_NUM_LEN);
 	memcpy((void *)serial_num,
 			(void *)ioc->attr->brcd_serialnum,
 			BFA_ADAPTER_SERIAL_NUM_LEN);
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 555e7db..9527fdb 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3197,7 +3197,6 @@ bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 		goto out_free_mem;
 
 	/* copy the linear bsg buffer to buf_info */
-	memset(buf_info->virt, 0, buf_info->size);
 	memcpy(buf_info->virt, payload_kbuf, buf_info->size);
 
 	/*
-- 
1.7.10.4

