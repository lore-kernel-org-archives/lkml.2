Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab0GOSnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:43:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63172 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060Ab0GOSnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LIfF6GIWE1Y9FFc7rtXQWyOQu8KdSg7gxpZ2RZHVBdNsVgx3s8pfOQypc7IeuwJUsJ
         W5d57/f+NrTX3Rc7cr40/mat+HXvyTicuyqvdyqme2bPWrMqgxspiudW1Mx7ED2fviUd
         SjVjRX064jXMSp/FHwkDJ66PJaxXBD+Sm0UAE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] arm/mach-tegra: fix unsigned calcs
Date: Thu, 15 Jul 2010 22:43:15 +0400
Message-Id: <1279219395-12088-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

divider_u71 is unsigned, so this check is buggy:
if (divider_u71 - 2 > 255 || divider_u71 - 2 < 0)

If divider_u71 is 0 or 1 both checks are lying.
So, it does not produce a buggy answer, but it is confusing.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/arm/mach-tegra/tegra2_clocks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 4261632..64df5b4 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -149,7 +149,7 @@ static int clk_div71_get_divider(struct clk *c, unsigned long rate)
 
 	divider_u71 = DIV_ROUND_UP(c->rate * 2, rate);
 
-	if (divider_u71 - 2 > 255 || divider_u71 - 2 < 0)
+	if (divider_u71 > 2 + 255 || divider_u71 < 2)
 		return -EINVAL;
 
 	return divider_u71 - 2;
-- 
1.7.0.4

