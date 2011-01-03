Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab1ACNya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:54:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab1ACNug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kYL8cPSjsYhUQ1oox6chrW2RZdz7fotM4lazu14F77HulmrHZMwr68KTa4au7swQso
         c/U1kAB0v3wPLj2R/bKAz+LzUpe1LdOgOpVYs6aEaFrH6A56KiJG/4w2dbQrlzEAMOB/
         aoI3MVUCtpthVc+Zs2PiucavgS0o8n6qDmHDc=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <tomof@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 18/32] scsi/scsi_tgt_lib: scsi_tgtd isn't used in memory reclaim path
Date: Mon,  3 Jan 2011 14:49:41 +0100
Message-Id: <1294062595-30097-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue scsi_tgtd isn't used during memory reclaim.  Convert to
alloc_workqueue() without WQ_MEM_RECLAIM.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <tomof@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/scsi/scsi_tgt_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index c399be9..f672820 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -629,7 +629,7 @@ static int __init scsi_tgt_init(void)
 	if (!scsi_tgt_cmd_cache)
 		return -ENOMEM;
 
-	scsi_tgtd = create_workqueue("scsi_tgtd");
+	scsi_tgtd = alloc_workqueue("scsi_tgtd", 0, 1);
 	if (!scsi_tgtd) {
 		err = -ENOMEM;
 		goto free_kmemcache;
-- 
1.7.1

