Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2JZAIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:08:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:53916 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab2JZAIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 56/85] pinctrl: remove mutex lock in groups show
Date: Thu, 25 Oct 2012 17:06:14 -0700
Message-Id: <20121026000036.749994637@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haojian Zhuang <haojian.zhuang@gmail.com>

commit 7ae9d71e8df27a3ab60a05ae3add08728debc09c upstream.

Mutex is locked duplicatly by pinconf_groups_show() and
pin_config_group_get(). It results dead lock. So avoid to lock mutex
in pinconf_groups_show().

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinconf.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -537,8 +537,6 @@ static int pinconf_groups_show(struct se
 	seq_puts(s, "Pin config settings per pin group\n");
 	seq_puts(s, "Format: group (name): configs\n");
 
-	mutex_lock(&pinctrl_mutex);
-
 	while (selector < ngroups) {
 		const char *gname = pctlops->get_group_name(pctldev, selector);
 
@@ -549,8 +547,6 @@ static int pinconf_groups_show(struct se
 		selector++;
 	}
 
-	mutex_unlock(&pinctrl_mutex);
-
 	return 0;
 }
 


