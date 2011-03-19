Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab1CSRqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 13:46:34 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:56193 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab1CSRqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 13:46:31 -0400
From: kernel@wildgooses.com
To: lists@wildgooses.com, grant.likely@secretlab.ca, dilinger@queued.net
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: Show explicit dependency between GPIO_CS5535 and MFD_CS5535
Date: Sat, 19 Mar 2011 17:46:25 +0000
Message-Id: <1300556785-30368-1-git-send-email-kernel@wildgooses.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <AANLkTinJNFZ-c_+Cuan5ebuRadrOvdfivxQjnN9GZPt=@mail.gmail.com>
References: <AANLkTinJNFZ-c_+Cuan5ebuRadrOvdfivxQjnN9GZPt=@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ed Wildgoose <kernel@wildgooses.com>

cs5535-gpio.c has been split into two, with various setup moved
into cs5535-mfd.c.  Given that cs5535-gpio will not load without
the -mfd part, lets make that dependency explicit in Kconfig

Signed-off-by: Ed Wildgoose <kernel@wildgooses.com>
---
:100644 100644 664660e... 3246ad4... M	drivers/gpio/Kconfig
 drivers/gpio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 664660e..3246ad4 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -295,7 +295,7 @@ comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
 	tristate "AMD CS5535/CS5536 GPIO support"
-	depends on PCI && X86 && !CS5535_GPIO
+	depends on PCI && X86 && !CS5535_GPIO && MFD_CS5535
 	help
 	  The AMD CS5535 and CS5536 southbridges support 28 GPIO pins that
 	  can be used for quite a number of things.  The CS5535/6 is found on
-- 
1.7.4

