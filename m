Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103Ab2CAT1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:27:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46848 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965040Ab2CAT1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:27:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.185.168 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 8/8] ARM: tegra: HACK: remove set_irq_flags() from driver
Date: Thu,  1 Mar 2012 14:26:50 -0500
Message-Id: <1330630010-11241-9-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330630010-11241-1-git-send-email-alan@signal11.us>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver should not call set_irq_flags itself, and
cannot do this from a loadable module.

Remove the call for now, which might break the driver
but at least lets the kernel link again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/host/ehci-tegra.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index dbc7fe8..ab91f26 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -729,7 +729,6 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		err = -ENODEV;
 		goto fail;
 	}
-	set_irq_flags(irq, IRQF_VALID);
 
 #ifdef CONFIG_USB_OTG_UTILS
 	if (pdata->operating_mode == TEGRA_USB_OTG) {
-- 
1.7.0.4

