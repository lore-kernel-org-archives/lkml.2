Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1J1Djh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:39:37 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:47896 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab1J1Djg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:39:36 -0400
From: Barry Song <Barry.Song@csr.com>
To: <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <workgroup.linux@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] pinctrl: Fix "warning: 'struct pinctrl_dev' declared inside parameter list"
Date: Thu, 27 Oct 2011 20:38:24 -0700
Message-ID: <1319773104-3541-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

when pinctl subsystem is not selected, when compiling drivers including
the include/linux/pinctrl/pinctrl.h, we will get the warning as below:
In file included from include/linux/pinctrl/pinmux.h:17,
                 from drivers/tty/serial/sirfsoc_uart.c:25:
include/linux/pinctrl/pinctrl.h:126: warning: 'struct pinctrl_dev'
		declared inside parameter list
include/linux/pinctrl/pinctrl.h:126: warning: its scope is only this
      definition or declaration, which is probably not what you want

Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 include/linux/pinctrl/pinctrl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 3605e94..04c0110 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -121,6 +121,7 @@ extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
 extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
 #else
 
+struct pinctrl_dev;
 
 /* Sufficiently stupid default function when pinctrl is not in use */
 static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
