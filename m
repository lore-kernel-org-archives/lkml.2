Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab2HJCGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:06:33 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:43585
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756042Ab2HJCGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:06:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8IOIN-02-0OX-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: Borislav Petkov <borislav.petkov@amd.com>, Lin Ming <minggr@gmail.com>,
        Len Brown <lenb@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Aaron Lu <aaron.lu@amd.com>, <stable@vger.kernel.org>,
        <3.5+@domain.invalid>
Subject: [PATCH] ACPI: power: Use KERN_DEBUG when no power resources are found
Date: Fri, 10 Aug 2012 10:05:53 +0800
Message-ID: <1344564353-493-1-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
X-OriginalArrivalTime: 10 Aug 2012 02:05:54.0615 (UTC) FILETIME=[AC96C470:01CD769C]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a606dac368eed5696fb38e16b1394f1d049c09e9 adds support to link
devices which have _PRx, if a device does not have _PRx, a warning
message will be printed.

This commit is for ZPODD on Intel's platform, on AMD's platform, there
is no _PRx to support ZPODD, we use _PSx.

So instead of printing a useless warning message on AMD's platform,
changing the print level to DEBUG to suppress this message.

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: <stable@vger.kernel.org> 3.5+
Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/acpi/power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 215ecd0..e5e01d9 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -460,7 +460,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
 	return ret;
 
 no_power_resource:
-	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
+	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!");
 	return -ENODEV;
 }
 EXPORT_SYMBOL_GPL(acpi_power_resource_register_device);
-- 
1.7.11.3


