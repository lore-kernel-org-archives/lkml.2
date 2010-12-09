Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0LIPMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:12:41 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36848 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0LIPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:11:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VvzioUSJi+erzxA9vQ4CQsJxoKAFRhrVO30U7Fepd8Yvsly6/Fe5APJQrN9ski1Xlw
         9fxP0soA10NDyY3oHat1HJnX+LB+GQ0BEYT7gallwpLjYMz6+ctwhS0amPP78nSWsuHs
         WtvFc7M8KVU6Yzo1VWl5ZZZQ0EdoHVj7rZIjY=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 3/8] staging: ft1000: Use return value for ft1000InitProc.
Date: Thu,  9 Dec 2010 16:13:49 +0100
Message-Id: <1291907634-22437-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add checking for return value ft1000InitProc and cleanup
if something fail.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 7dfed41..0e1fc3f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -198,12 +198,17 @@ static int ft1000_probe(struct usb_interface *interface,
 	if (ret)
 		goto err_thread;
 
-	pft1000info->NetDevRegDone = 1;
+	ret = ft1000InitProc(ft1000dev->net);
+	if (ret)
+		goto err_proc;
 
-	ft1000InitProc(ft1000dev->net);
+	pft1000info->NetDevRegDone = 1;
 
 	return 0;
 
+err_proc:
+	unregister_netdev(ft1000dev->net);
+	free_netdev(ft1000dev->net);
 err_thread:
 	kthread_stop(pft1000info->pPollThread);
 err_load:
-- 
1.7.1

