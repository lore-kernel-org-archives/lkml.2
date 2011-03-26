Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1CZQQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:16:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1CZQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZaUMPJBvpwhLQJ11qpdiHQFoyT0ozKoU1QPDuZKBHwBhKMcp1F5M+BkjOjmde0fWjk
         bbNky0G3xM2yFBlEnF7FP/d4ws+u96HCCS2o11e/2dw1dt50Pvmj2Y+DjnTUAmoR/YA8
         s1r9+dFn6ZZ0igJzMWc1qFFic6Ai0gPnmT30E=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH 4/4] staging: keucr: smscsi: Removed unreachable return statements.
Date: Sat, 26 Mar 2011 17:16:20 +0100
Message-Id: <1301156180-12192-4-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
References: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unreachable return statements and simplify the logic by
avoid else-cases where it's not necessary.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/staging/keucr/smscsi.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
index f857be7..38d4ab3 100644
--- a/drivers/staging/keucr/smscsi.c
+++ b/drivers/staging/keucr/smscsi.c
@@ -54,8 +54,6 @@ int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
 		ENE_SMInit(us);
 		return USB_STOR_TRANSPORT_GOOD;
 	}
-
-	return USB_STOR_TRANSPORT_GOOD;
 }
 
 int SM_SCSI_Inquiry(struct us_data *us, struct scsi_cmnd *srb)
@@ -141,10 +139,8 @@ int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 
 	if (!result)
 		return USB_STOR_TRANSPORT_GOOD;
-	else
-		return USB_STOR_TRANSPORT_ERROR;
 
-	return USB_STOR_TRANSPORT_GOOD;
+	return USB_STOR_TRANSPORT_ERROR;
 }
 
 int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
@@ -170,9 +166,7 @@ int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 
 	if (!result)
 		return USB_STOR_TRANSPORT_GOOD;
-	else
-		return USB_STOR_TRANSPORT_ERROR;
 
-	return USB_STOR_TRANSPORT_GOOD;
+	return USB_STOR_TRANSPORT_ERROR;
 }
 
-- 
1.7.4.1

