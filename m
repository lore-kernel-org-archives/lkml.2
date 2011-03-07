Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1CGFuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 00:50:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57415 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1CGFuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 00:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NMWi6/A/3OhG2l/Ox91geNm+Ex1WR6UPiFqBjZPIS049fKlrhpAObscOR75lwKNUw6
         F3jHM0NYlPNWNvpwaZTmYa27zUYvKLvVNV0XUela+2s5YCBrNTdaHTM1sq0ckOklg6Vd
         46CDKT2kx4HoGn3fIiySYIZR9sd83POp/B5co=
Subject: [PATCH 1/2] [ARM] am200epd: fix resource leak in
	am200_init_gpio_regs error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain
Date: Mon, 07 Mar 2011 13:55:15 +0800
Message-Id: <1299477315.10486.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gpio_request fails when i > 0, gpios[0] is not freed in current
implementation.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-pxa/am200epd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/am200epd.c b/arch/arm/mach-pxa/am200epd.c
index 3499fad..811d797 100644
--- a/arch/arm/mach-pxa/am200epd.c
+++ b/arch/arm/mach-pxa/am200epd.c
@@ -128,8 +128,8 @@ static int am200_init_gpio_regs(struct metronomefb_par *par)
 	return 0;
 
 err_req_gpio:
-	while (i > 0)
-		gpio_free(gpios[i--]);
+	while (--i >= 0)
+		gpio_free(gpios[i]);
 
 	return err;
 }
-- 
1.7.2



