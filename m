Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1ABHat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:30:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:38200 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab1ABHaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:30:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 240/260] p54usb: fix off-by-one on !CONFIG_PM
Date: Sun,  2 Jan 2011 02:18:56 -0500
Message-Id: <1293952756-15010-241-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:32.0292 (UTC) FILETIME=[198B4640:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Lamparter <chunkeey@googlemail.com>

commit 11791a6f7534906b4a01ffb54ba0b02ca39398ef upstream.

The ISL3887 chip needs a USB reset, whenever the
usb-frontend module "p54usb" is reloaded.

This patch fixes an off-by-one bug, if the user
is running a kernel without the CONFIG_PM option
set and for some reason (e.g.: compat-wireless)
wants to switch between different p54usb modules.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/p54/p54usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 186dc71..602498a 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -931,8 +931,8 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 #ifdef CONFIG_PM
 		/* ISL3887 needs a full reset on resume */
 		udev->reset_resume = 1;
+#endif /* CONFIG_PM */
 		err = p54u_device_reset(dev);
-#endif
 
 		priv->hw_type = P54U_3887;
 		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
-- 
1.7.3.3

