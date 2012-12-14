Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab2LNW2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:28:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:38481 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab2LNW2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:28:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chen Gang <gang.chen@asianux.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ 11/28] telephony: ijx: buffer overflow in ixj_write_cid()
Date: Fri, 14 Dec 2012 14:26:28 -0800
Message-Id: <20121214222253.041288747@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222250.501309822@linuxfoundation.org>
References: <20121214222250.501309822@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

[Not needed in 3.8 or newer as this driver is removed there. - gregkh]

We get this from user space and nothing has been done to ensure that
these strings are NUL terminated.

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/telephony/ixj.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

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


