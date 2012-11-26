Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2KZRbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:31:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48023 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933823Ab2KZRND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 210/270] pinctrl: fix missing unlock on error in pinctrl_groups_show()
Date: Mon, 26 Nov 2012 14:58:20 -0200
Message-Id: <1353949160-26803-211-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit b4dd784ba8af03bf1f9ee5118c792d7abd4919bd upstream.

Add the missing unlock on the error handle path in function
pinctrl_groups_show().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pinctrl/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 0cc053a..5e59c45 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1069,8 +1069,10 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
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
-- 
1.7.9.5

