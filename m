Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1BDMYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:24:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1BDMYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:24:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dAwa2y8b3hW8tRGfCNyvA+4d/7Ca19+yqvDqPA1Ryb9eTG2LY4J+XwUL+nL/la0mNA
         Yd0/bwNpPP/1cA/8xCUk5cIQ5F5mFP1agDxOo0EUcUGOkp/hBfLSFOcFoenAXlPMXk+l
         iNkPM8WlTxpTyb/tNC0GXGogQGTM4PnbI5P/g=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: [PATCH 17/20] rtc: rtc-ds1511: world-writable sysfs nvram file
Date: Fri,  4 Feb 2011 15:24:06 +0300
Message-Id: <48f518983fa454135d7cfadef120edab35c94329.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybogy to write to NVRAM.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/rtc/rtc-ds1511.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 37268e9..afeb546 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -485,7 +485,7 @@ ds1511_nvram_write(struct file *filp, struct kobject *kobj,
 static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = DS1511_RAM_MAX,
 	.read = ds1511_nvram_read,
-- 
1.7.0.4

