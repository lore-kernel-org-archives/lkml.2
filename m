Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2DTRWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:22:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36352 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab2DTRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:22:10 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: r8192e_pci: Change memcpy to memcmp
Date: Fri, 20 Apr 2012 12:21:26 -0500
Message-Id: <1334942486-9235-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.10.130.g36e6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Routine rtllib_MlmeDisassociateRequest() has a comparison of memcpy()
with NULL, which makes no sense. Analysis of the code suggests that
memcmp() was intended.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Greg,

This routine has never been entered in all my testing of this driver,
thus this patch has no particular priority.

Thanks,

Larry
---

 drivers/staging/rtl8192e/rtllib_softmac.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index c5a15db..703fa84 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -3679,8 +3679,7 @@ void rtllib_MlmeDisassociateRequest(struct rtllib_device *rtllib, u8 *asSta,
 
 	RemovePeerTS(rtllib, asSta);
 
-
-	if (memcpy(rtllib->current_network.bssid, asSta, 6) == NULL) {
+	if (memcmp(rtllib->current_network.bssid, asSta, 6) == NULL) {
 		rtllib->state = RTLLIB_NOLINK;
 
 		for (i = 0; i < 6; i++)
-- 
1.7.10.130.g36e6c

