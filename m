Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1FNLNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:13:07 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:42086 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1FNLNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Wbbhs25Lv5g15xhcXYW/uFmhKTXS82gGkWTeZi+EZJwk7fXtJCOblcgxkqqv656Yod
         El08/jqND/JyKUpEe75jbKNHo7iLpMKtYJsykJMH+9cGD9sNt6R9gH9gHv2zOxiRlaDt
         AOUVvJxMDjlz5u3hpJd5vmBWOv66iGP7IB0RQ=
Subject: [PATCH] gpio: gpio-ml-ioh: fix off-by-one for displaying variable
 i in dev_err
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 19:12:57 +0800
Message-ID: <1308049977.2671.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with the "for (; i != 0; i--)" sytax, i-- will be executed after the iteration.
thus dev_err shows wrong i value.
Switch to "while(--i >= 0)" which is better in readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-ml-ioh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 1bc621a..a9016f5 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -233,7 +233,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 	return 0;
 
 err_gpiochip_add:
-	for (; i != 0; i--) {
+	while (--i >= 0) {
 		chip--;
 		ret = gpiochip_remove(&chip->gpio);
 		if (ret)
-- 
1.7.4.1



