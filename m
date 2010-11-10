Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0KJI1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:27:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0KJI1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vlYRlMykO+fISmP7oyv+LXuMk3UahPNZCgekYupJMULOTaLFybyH2mNnVdHeY9lK7X
         FhBjKIKdCHKkFv581ldzMmEGSpA9M3TwVeqo26TGb7ASbBdzA4tvDHnsAybni4y3sGBh
         GzMBM9dBa6HTZEUb7wru2QHdcx0HrWWB0Tfg0=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging: ft1000: Check return value of kthread_run.
Date: Wed, 10 Nov 2010 09:29:35 +0100
Message-Id: <1289377775-13421-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kthread_run could fail so we will check return value.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 41bbe99..dcbc97c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -175,6 +175,12 @@ static int ft1000_probe(struct usb_interface *interface,
 	gPollingfailed = FALSE;
 	pft1000info->pPollThread =
 	    kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
+
+	if (IS_ERR(pft1000info->pPollThread)) {
+		ret = PTR_ERR(pft1000info->pPollThread);
+		goto err_load;
+	}
+
 	msleep(500);
 
 	while (!pft1000info->CardReady) {
-- 
1.7.1

