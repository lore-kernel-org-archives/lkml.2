Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab0G2P4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:56:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57151 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab0G2P4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:56:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a2wtDYFQERRCWPBECn3tCuhBW3ij9fHkRh7EZePeyBOKqvuwgjUVL/NBYwUfyoDq0b
         afhZOXjIly0qZYy4VpNwhPIQUKRMdUVAB8ZYV46VSgpPLv4UqDYn6L0GcJJjd7NKeo1d
         QGKY6h5ywB9Y5TT/oCasSlftgyECSrl7ZK5CQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mac_scsi: check scsi_register() result
Date: Thu, 29 Jul 2010 19:56:25 +0400
Message-Id: <1280418986-6024-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi_register() may fail, if so return from detect() with negative
result.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/mac_scsi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index bf2a1c5..3ab601f 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -268,6 +268,9 @@ int macscsi_detect(struct scsi_host_template * tpnt)
     /* Once we support multiple 5380s (e.g. DuoDock) we'll do
        something different here */
     instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
+    if (instance == NULL)
+	return 0;
+
 #if NDEBUG
     default_instance = instance;
 #endif
-- 
1.7.0.4

