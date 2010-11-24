Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0KXJkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:40:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40013 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0KXJkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:40:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=icCLYiWp4WTJtSCTn30bcrTdf5nf7ua7x0CLYM75Iify4MQzHMMm5YdyYQKMK15N7d
         3xoiHrHVpiyEUby09W/l38sUgW1qYp2jr/iqCVwGTOWP5qN0Ydr4XEt6WfydgUpETQ+v
         b5rMQ1g23uAohZW3P11M6SxfHounfdC1tq2f0=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging: ft1000: Fix goto error logic.
Date: Wed, 24 Nov 2010 10:42:39 +0100
Message-Id: <1290591759-13839-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix goto error logic which could lead to kernel panics
because kthread_stop() is called in not correct error
conditions. Seen it sometimes when dsp_reload() fails
then I got kernel panic.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index f88ff86..d71ac30 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -204,9 +204,9 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	return 0;
 
-err_load:
-	kthread_stop(pft1000info->pPollThread);
 err_thread:
+	kthread_stop(pft1000info->pPollThread);
+err_load:
 	kfree(pFileStart);
 err_fw:
 	kfree(ft1000dev);
-- 
1.7.1

