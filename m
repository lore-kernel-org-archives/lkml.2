Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1FXJ7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 05:59:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55792 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1FXJ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 05:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=FQ3yKm6IskI2u7i1dg9WvPbgagBkPdMPDU1CWlIixcjsrLH3+kXgpT2cYHENhxfWY1
         w4D+4Xjjqh6wb4arzHdFeniCEprWKB23tG7+TzzUezwPdGkDw09TkTuwBEPCgD5KkRgV
         Zl8BVb9vlDLRUf7rytFKrRz9c24vulyat4k+k=
From: John Kacur <jkacur@redhat.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Eric Moore <eric.moore@lsi.com>, linux-scsi@vger.kernel.org,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH] [SCSI] mpt2sas: Remove duplicate code in mpt2sas_base_attach
Date: Fri, 24 Jun 2011 11:59:29 +0200
Message-Id: <1308909569-5293-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove this duplicate code I found by inspection.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index efa0255..2660b3c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3933,13 +3933,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		goto out_free_resources;
 	}
 
-	if (!ioc->base_cmds.reply || !ioc->transport_cmds.reply ||
-	    !ioc->scsih_cmds.reply || !ioc->tm_cmds.reply ||
-	    !ioc->config_cmds.reply || !ioc->ctl_cmds.reply) {
-		r = -ENOMEM;
-		goto out_free_resources;
-	}
-
 	init_completion(&ioc->shost_recovery_done);
 
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
-- 
1.7.2.3

