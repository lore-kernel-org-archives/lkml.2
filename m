Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1JAUFC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:05:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60397 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1JAUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:04:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 01/26] usb/gadget/pxa25x: is_vbus_present is gone
Date: Sat,  1 Oct 2011 22:03:33 +0200
Message-Id: <1317499438-14058-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:SVbUmEshytDTKsm10J/j6B/4goJlCUQMhRqlBGuuMY6
 IdeF8HgUhJTw5c9kmXMfgTFqSGO7g39W6JN1iuin1wzetqVCEO
 ypm16EjCSHNkZYmrqDwzb6KyziuAuFRmIVAjSbQiPJhuHfzELJ
 cuJycaBgN1ByMFKu91yInHRpW7x8o5GpxMTYhSMaD954bJtVTk
 hfD07hH6kBnCF6MNo7N+hpCdmtkDSSkjCO5Ezx+bU6EWygZ2yI
 1oQ61KcXoaBoPpjUsEWQ1fEKi41z4eqq5g0kobcEAfrn0qM8tR
 mKXxJs60qkwMMVo0/tqm8Bk8Az22owIXfJ9+C10EoYOkBzjxNn
 3T0V+Kuv6+p63V9U4F5dERlOwTwoVzruzt+hvL17FmBg0ZEw6+
 qaMyTk3onORqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent commit obsoleted the is_vbus_present function, so
we must not use it any more.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/pxa25x_udc.h |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/pxa25x_udc.h b/drivers/usb/gadget/pxa25x_udc.h
index f572c56..6119900 100644
--- a/drivers/usb/gadget/pxa25x_udc.h
+++ b/drivers/usb/gadget/pxa25x_udc.h
@@ -161,8 +161,6 @@ static struct pxa25x_udc *the_controller;
 
 #ifdef DEBUG
 
-static int is_vbus_present(void);
-
 static const char *state_name[] = {
 	"EP0_IDLE",
 	"EP0_IN_DATA_PHASE", "EP0_OUT_DATA_PHASE",
@@ -214,8 +212,7 @@ dump_state(struct pxa25x_udc *dev)
 	u32		tmp;
 	unsigned	i;
 
-	DMSG("%s %s, uicr %02X.%02X, usir %02X.%02x, ufnr %02X.%02X\n",
-		is_vbus_present() ? "host " : "disconnected",
+	DMSG("%s, uicr %02X.%02X, usir %02X.%02x, ufnr %02X.%02X\n",
 		state_name[dev->ep0state],
 		UICR1, UICR0, USIR1, USIR0, UFNRH, UFNRL);
 	dump_udccr("udccr");
@@ -232,9 +229,6 @@ dump_state(struct pxa25x_udc *dev)
 	} else
 		DMSG("ep0 driver '%s'\n", dev->driver->driver.name);
 
-	if (!is_vbus_present())
-		return;
-
 	dump_udccs0 ("udccs0");
 	DMSG("ep0 IN %lu/%lu, OUT %lu/%lu\n",
 		dev->stats.write.bytes, dev->stats.write.ops,
-- 
1.7.5.4

