Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2CFWZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:25:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46979 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895Ab2CFWZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:25:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.42.18.195 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <4F565C04.1030202@ru.mvista.com>
References: <1331038557-1398-1-git-send-email-linus.walleij@stericsson.com>
	<4F565C04.1030202@ru.mvista.com>
Date: Tue, 6 Mar 2012 23:25:36 +0100
Message-ID: <CACRpkdYdzTBiHKod+tzM4tPbYgRaNU=aRdqCnTQ6urqbT4vayQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: include machine header to core.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 7:48 PM, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

>   I don't see where you touch kernel-doc...

Bah, missed to git add it. Here is the new patch:

>From 872acc322c74bb06b7ceb61fe93314e2da32362c Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 6 Mar 2012 13:52:22 +0100
Subject: [PATCH] pinctrl: include machine header to core.h

struct pinctrl_setting contains an enum pinctrl_map_type
field, so we need to include machine.h. Also fix kerneldoc
to indicate that the pinctrl_setting is about both muxing
and other config.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 5b3ff13..efbfb62 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -12,6 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/radix-tree.h>
 #include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/machine.h>

 struct pinctrl_gpio_range;

@@ -96,7 +97,7 @@ struct pinctrl_setting_configs {
 };

 /**
- * struct pinctrl_setting - an individual mux setting
+ * struct pinctrl_setting - an individual mux or config setting
  * @node: list node for struct pinctrl_settings's @settings field
  * @type: the type of setting
  * @pctldev: pin control device handling to be programmed
-- 
1.7.8
