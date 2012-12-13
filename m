Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab2LMOS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:18:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442Ab2LMOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 231/241] telephony: ijx: buffer overflow in ixj_write_cid()
Date: Thu, 13 Dec 2012 11:59:56 -0200
Message-Id: <1355407206-17100-232-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[Not needed in 3.8 or newer as this driver is removed there. - gregkh]

We get this from user space and nothing has been done to ensure that
these strings are NUL terminated.

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/telephony/ixj.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/telephony/ixj.c b/drivers/staging/telephony/ixj.c
index fd7757a..93ff7af 100644
--- a/drivers/staging/telephony/ixj.c
+++ b/drivers/staging/telephony/ixj.c
@@ -3190,12 +3190,12 @@ static void ixj_write_cid(IXJ *j)
 
 	ixj_fsk_alloc(j);
 
-	strcpy(sdmf1, j->cid_send.month);
-	strcat(sdmf1, j->cid_send.day);
-	strcat(sdmf1, j->cid_send.hour);
-	strcat(sdmf1, j->cid_send.min);
-	strcpy(sdmf2, j->cid_send.number);
-	strcpy(sdmf3, j->cid_send.name);
+	strlcpy(sdmf1, j->cid_send.month, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.day, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.hour, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.min, sizeof(sdmf1));
+	strlcpy(sdmf2, j->cid_send.number, sizeof(sdmf2));
+	strlcpy(sdmf3, j->cid_send.name, sizeof(sdmf3));
 
 	len1 = strlen(sdmf1);
 	len2 = strlen(sdmf2);
@@ -3340,12 +3340,12 @@ static void ixj_write_cidcw(IXJ *j)
 		ixj_pre_cid(j);
 	}
 	j->flags.cidcw_ack = 0;
-	strcpy(sdmf1, j->cid_send.month);
-	strcat(sdmf1, j->cid_send.day);
-	strcat(sdmf1, j->cid_send.hour);
-	strcat(sdmf1, j->cid_send.min);
-	strcpy(sdmf2, j->cid_send.number);
-	strcpy(sdmf3, j->cid_send.name);
+	strlcpy(sdmf1, j->cid_send.month, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.day, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.hour, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.min, sizeof(sdmf1));
+	strlcpy(sdmf2, j->cid_send.number, sizeof(sdmf2));
+	strlcpy(sdmf3, j->cid_send.name, sizeof(sdmf3));
 
 	len1 = strlen(sdmf1);
 	len2 = strlen(sdmf2);
-- 
1.7.9.5

