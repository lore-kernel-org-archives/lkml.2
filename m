Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab2L1Tyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:54:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55004 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428Ab2L1TRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:13 -0500
Message-Id: <20121228190401.441155002@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chen Gang <gang.chen@asianux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 161/173] telephony: ijx: buffer overflow in ixj_write_cid()
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[Not needed in 3.8 or newer as this driver is removed there. - gregkh]

We get this from user space and nothing has been done to ensure that
these strings are NUL terminated.

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/telephony/ixj.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index d5f923b..e1abb45 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
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


