Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1D1IdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:33:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44270 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab1D1IdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XxRu6dcl1Cud99VFxPpopC0FY/uxOYkJ5XKrqDaKv9dW0HzhVpQMD8hETi95ME0b2e
         b7wUFfAkW6Yd8CFQARIHJJLCkkRJWSKPJIEFFRgaDwAFeH2OxBjs9r7WYEstRyr0vWG+
         7zEc5IpsuFG3KXd/nMAld2EYNBL9+vInv8jyM=
From: Lifeng Sun <lifongsun@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Lifeng Sun <lifongsun@gmail.com>
Subject: [PATCH 5/5] drivers/char/applicom.c: ac_ioctl should not always returns 0
Date: Thu, 28 Apr 2011 16:32:36 +0800
Message-Id: <1303979556-30494-2-git-send-email-lifongsun@gmail.com>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <1303979556-30494-1-git-send-email-lifongsun@gmail.com>
References: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
 <1303979556-30494-1-git-send-email-lifongsun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should return error code properly instead of always returning 0.

This driver does not seem to be actively maintained from my brief
investigation. Apologies to the maintainers that I have missed.

Signed-off-by: Lifeng Sun <lifongsun@gmail.com>
---
 drivers/char/applicom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 25373df..50c09e4 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -838,6 +838,6 @@ static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	Dummy = readb(apbs[IndexCard].RamIO + VERS);
 	kfree(adgl);
 	mutex_unlock(&ac_mutex);
-	return 0;
+	return ret;
 }
 
-- 
1.7.5.rc1

