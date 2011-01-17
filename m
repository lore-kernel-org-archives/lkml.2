Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1AQKJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:09:44 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34325 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1AQKIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=KUjE9Fc2/9DWuv4fpodjS+2vd1HsgVqbFaT7zPC7sgtuOwmVuQNeHUt8pFvTGnfMc3
         a7vwHZMfGqVwd3cCN5AdKSSTddsl5215D0Nh1UnMkWmjytVteVwDkbnktP95LGGbvotF
         Ym3RrXlbkHD47qu0qUIkOGo4FwlsO571YMYCM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm: mach-omap2: potential NULL dereference
Date: Mon, 17 Jan 2011 13:08:42 +0300
Message-Id: <1295258922-31242-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc() may fail, if so return -ENOMEM.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 arch/arm/mach-omap2/smartreflex.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 77ecebf..871bca9 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -260,7 +260,10 @@ static int sr_late_init(struct omap_sr *sr_info)
 	if (sr_class->class_type == SR_CLASS2 &&
 		sr_class->notify_flags && sr_info->irq) {
 
+		ret = -ENOMEM;
 		name = kzalloc(SMARTREFLEX_NAME_LEN + 1, GFP_KERNEL);
+		if (name == NULL)
+			goto error;
 		strcpy(name, "sr_");
 		strcat(name, sr_info->voltdm->name);
 		ret = request_irq(sr_info->irq, sr_interrupt,
-- 
1.7.0.4

