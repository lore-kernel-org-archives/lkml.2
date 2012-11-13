Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2KMHbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:31:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2KMHbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:31:52 -0500
Message-ID: <1352791901.3947.1.camel@phoenix>
Subject: [PATCH] pinctrl: spear: Fix the logic of setting reg in
 pmx_init_gpio_pingroup_addr
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Nov 2012 15:31:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not work if count > 1, fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/spear/pinctrl-spear.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
index f9483ae..107780c 100644
--- a/drivers/pinctrl/spear/pinctrl-spear.c
+++ b/drivers/pinctrl/spear/pinctrl-spear.c
@@ -86,10 +86,10 @@ void __devinit
 pmx_init_gpio_pingroup_addr(struct spear_gpio_pingroup *gpio_pingroup,
 		unsigned count, u16 reg)
 {
-	int i = 0, j = 0;
+	int i, j;
 
-	for (; i < count; i++)
-		for (; j < gpio_pingroup[i].nmuxregs; j++)
+	for (i = 0; i < count; i++)
+		for (j = 0; j < gpio_pingroup[i].nmuxregs; j++)
 			gpio_pingroup[i].muxregs[j].reg = reg;
 }
 
-- 
1.7.9.5



