Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab0I0HIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:08:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55488 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab0I0HIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:08:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GjH6cfIP3QAa1MIlTnOpLvWJr4De/1Oht2IBJPmYivb6CcjrqeWDmNZevCmcuc+bty
         3lw9EWSKEdeZC0aNgi8/7ZbfFJwIdrcvqpJHQN7WFVrFNe/VTaiQ27rfp2d3s7caR1w4
         QrONs5iw+vLulla/ZDtyibuej79IQHPn+SH74=
Subject: [PATCH 2/3] drivers/power: add missing kfree(jz_battery) in
	jz_battery_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <1285571232.31251.1.camel@mola>
References: <1285571232.31251.1.camel@mola>
Content-Type: text/plain
Date: Mon, 27 Sep 2010 15:08:31 +0800
Message-Id: <1285571311.31251.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/jz4740-battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 20c4b95..a8108a7 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -383,6 +383,7 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
 
 	iounmap(jz_battery->base);
 	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
+	kfree(jz_battery);
 
 	return 0;
 }
-- 
1.7.2



