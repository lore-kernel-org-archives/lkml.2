Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2JVE6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:58:12 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33720 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2JVE6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:58:10 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 12:58:09 +0800
Message-ID: <CAPgLHd_ogKwOa26a3jLGGMDOTNLemD+xynzWK87-YyvQ2Zm0VA@mail.gmail.com>
Subject: [PATCH] pinctrl: fix missing unlock on error in pinctrl_groups_show()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handle path in function
pinctrl_groups_show().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 0f1ec9e..2e39c04 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1061,8 +1061,10 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 			seq_printf(s, "group: %s\n", gname);
 			for (i = 0; i < num_pins; i++) {
 				pname = pin_get_name(pctldev, pins[i]);
-				if (WARN_ON(!pname))
+				if (WARN_ON(!pname)) {
+					mutex_unlock(&pinctrl_mutex);
 					return -EINVAL;
+				}
 				seq_printf(s, "pin %d (%s)\n", pins[i], pname);
 			}
 			seq_puts(s, "\n");


