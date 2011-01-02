Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1ABH0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:26:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:37188 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab1ABHZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 251/260] USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled
Date: Sun,  2 Jan 2011 02:19:07 -0500
Message-Id: <1293952756-15010-252-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:44.0074 (UTC) FILETIME=[209110A0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit 969affff54702785330de553b790372e261e93f9 upstream.

to ensure gpio_is_valid return false

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/gadget/atmel_usba_udc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 75a256f..8fd88e1 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -2015,6 +2015,9 @@ static int __init usba_udc_probe(struct platform_device *pdev)
 			} else {
 				disable_irq(gpio_to_irq(udc->vbus_pin));
 			}
+		} else {
+			/* gpio_request fail so use -EINVAL for gpio_is_valid */
+			ubc->vbus_pin = -EINVAL;
 		}
 	}
 
-- 
1.7.3.3

