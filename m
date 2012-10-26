Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2JZAPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:15:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:53928 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab2JZAIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 57/85] pinctrl: fix missing unlock on error in pinctrl_groups_show()
Date: Thu, 25 Oct 2012 17:06:15 -0700
Message-Id: <20121026000036.847698116@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit b4dd784ba8af03bf1f9ee5118c792d7abd4919bd upstream.

Add the missing unlock on the error handle path in function
pinctrl_groups_show().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1059,8 +1059,10 @@ static int pinctrl_groups_show(struct se
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


