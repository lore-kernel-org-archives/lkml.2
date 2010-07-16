Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935532Ab0GPDDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:03:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46212 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935391Ab0GPDDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=DiOItfCy6heU1RG8hGUOU47GSFcuDna6aU83kHKWex0av4dmV/NPkuclBJt8Gu6a/d
         D7/tL9J34PbCYeOyq7s92xGxYpjspbW94Wbe1ChGQlaSZSDxkxid2c7bOU/1h8OxeEcZ
         TJNrLdCYuX1TN/YKxlVWDEmZoH8HRAI4fRyEM=
Message-ID: <4C3FCBFF.50506@gmail.com>
Date: Fri, 16 Jul 2010 11:03:27 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM/nuc900: fix nuc900 touchscreen clk definition bug
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix nuc900 touchscreen clk definition bug,the .dev_id's
name should be 'nuc900-ts', it should be the same to pdev.name. or else,
the touchscreen driver will be not working well due to clock engine disabled.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 642207e..83c5632 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -93,7 +93,7 @@ static struct clk_lookup nuc900_clkregs[] = {
 	DEF_CLKLOOK(&clk_kpi, "nuc900-kpi", NULL),
 	DEF_CLKLOOK(&clk_wdt, "nuc900-wdt", NULL),
 	DEF_CLKLOOK(&clk_gdma, "nuc900-gdma", NULL),
-	DEF_CLKLOOK(&clk_adc, "nuc900-adc", NULL),
+	DEF_CLKLOOK(&clk_adc, "nuc900-ts", NULL),
 	DEF_CLKLOOK(&clk_usi, "nuc900-spi", NULL),
 	DEF_CLKLOOK(&clk_ext, NULL, "ext"),
 	DEF_CLKLOOK(&clk_timer0, NULL, "timer0"),
-- 
1.6.3.3
