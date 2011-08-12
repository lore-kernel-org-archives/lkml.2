Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1HLDfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:35:37 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:44052 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1HLDfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=kylemanna.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=
	kylemanna.com; b=rkU5QvHmNQq2e6uW5NEt0XDXzbcOrDf4qXyKrdRs7n8rLfo
	J7WrzmCMUZ4kzU+Z1/TP4qIlAVHbeFZrPFPdKs0qrz81Hq+VZZhbxhItYGQYHMEf
	2PVwxgYRMOiuO+0dGFfEzBYqe+dyRRxAxkJ4vnu/5Uv+lpZd3rzDIK6dLeOU=
From: Kyle Manna <kyle@kylemanna.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Keerthy <j-keerthy@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyle Manna <kyle@kylemanna.com>
Subject: [PATCH v2 3/4] mfd: twl4030-madc: check for NULL pointer
Date: Thu, 11 Aug 2011 22:33:14 -0500
Message-Id: <1313119995-15382-4-git-send-email-kyle@kylemanna.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
References: <CANOLnOPB=wFMPwqGbu9ufh__iM7TquUx3-o95R=gyJcae+gENg@mail.gmail.com>
 <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the twl4030-madc device wasn't registered, and another device, such
as twl4030-madc-hwmon, calls twl4030_madc_conversion() a NULL pointer is
dereferenced.

Signed-off-by: Kyle Manna <kyle@kylemanna.com>
---
 drivers/mfd/twl4030-madc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 99dd611..834f824 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -510,8 +510,9 @@ int twl4030_madc_conversion(struct twl4030_madc_request *req)
 	u8 ch_msb, ch_lsb;
 	int ret;
 
-	if (!req)
+	if (!req || !twl4030_madc)
 		return -EINVAL;
+
 	mutex_lock(&twl4030_madc->lock);
 	if (req->method < TWL4030_MADC_RT || req->method > TWL4030_MADC_SW2) {
 		ret = -EINVAL;
-- 
1.7.4.1

