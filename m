Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab1F1CrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:47:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53545 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1F1Cqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Awqo4QC8/Q8wKf5GRulb53mHcdkYzw3qwlIkCDLguv5ZWnKZINGy6Kwz3AvMBLEQwC
         xGSKBtZAT9EgE+OPELIQV8s3Zq8ab+XPX2Sk7j7fxQyutw8Tclyo3BltK7o8at2t7e0q
         uUKbpHD++lmtXnwAvJmraYPD28iqTUmMpKgGw=
Subject: [PATCH] Input: gpio_keys - fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Phil Blundell <pb@handhelds.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 10:46:21 +0800
Message-ID: <1309229181.5235.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/gpio_keys.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 6d0e2f6..cc4bdec 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -569,6 +569,7 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 	}
 
 	input_unregister_device(input);
+	kfree(ddata);
 
 	return 0;
 }
-- 
1.7.4.1



