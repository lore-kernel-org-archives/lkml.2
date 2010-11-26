Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0KZLHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:07:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46609 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab0KZLH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:07:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DszO9rmSP6By0kU08nAoAwTma5Lg4p/owP9/m15SVWPIitt3rEdrfBBR2E+xCWbJwM
         Ap9TrMvs8D6hOixnjvIpNahpKkMULYSBh1IWQ+DKpB2qZYzlzxNG1FU/151ecnYs+Yt+
         vOLSl4skzrMxEuWkFEYT6J3xXkRki4siTWvCc=
From: Al Cho <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, jlee@novell.com, acho@novell.com,
        segooon@gmail.com, error27@gmail.com
Subject: [PATCH 2/2] staging/keucr: fix keucr init other coding style
Date: Fri, 26 Nov 2010 19:07:27 +0800
Message-Id: <61f99cb160446c28ce1930945bb23d4864897d32.1290769009.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <7d028296d825e8f48007f5ad9b642be6e27dc612.1290769009.git.acho@novell.com>
References: <7d028296d825e8f48007f5ad9b642be6e27dc612.1290769009.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr init.c other coding style but not from checkpatch.pl.
replace ternary conditional "?:" with if/else.

Signed-off-by: Al Cho <acho@novell.com>
---
 drivers/staging/keucr/init.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index e6c56de..515e448 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -364,8 +364,13 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 	}
 
 	if (buf) {
-		unsigned int pipe = fDir ==
-			FDIR_READ ? us->recv_bulk_pipe : us->send_bulk_pipe;
+		unsigned int pipe = fDir;
+
+		if (fDir == FDIR_READ)
+			pipe = us->recv_bulk_pipe;
+		else
+			pipe = us->send_bulk_pipe;
+
 		/* Bulk */
 		if (use_sg)
 			result = usb_stor_bulk_srb(us, pipe, us->srb);
-- 
1.7.1

