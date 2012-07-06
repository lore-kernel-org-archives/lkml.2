Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2GFHwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:52:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40745 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2GFHws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:52:48 -0400
Message-ID: <4FF6994B.9040801@linaro.org>
Date: Fri, 06 Jul 2012 08:52:43 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com
CC: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Content-Type: multipart/mixed;
 boundary="------------000203080400030203050104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000203080400030203050104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry Dmitry, looks like I missed you off of the CC list on this one.

Here it is again:

Before we can use any domain allocated IRQ, we need to first create a
map between the Hardware IRQ (hwirq) and the Linux Virtual IRQ (virq).
We do this with a helper function provided by the AB8500 IRQ domain
controller called ab8500_irq_get_virq(). We need to do this for both
IRQs which the Power-On-Key driver uses; one for button press, the other
for button depress.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/input/misc/ab8500-ponkey.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
index 5ceb23e..ae4b683 100644
--- a/drivers/input/misc/ab8500-ponkey.c
+++ b/drivers/input/misc/ab8500-ponkey.c
@@ -82,6 +82,7 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
  	input_set_capability(input, EV_KEY, KEY_POWER);
 +	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, ponkey->irq_dbf);
 	error = request_any_context_irq(ponkey->irq_dbf, ab8500_ponkey_handler,
 					0, "ab8500-ponkey-dbf", ponkey);
 	if (error < 0) {
@@ -90,6 +91,7 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
 		goto err_free_mem;
 	}
 +	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, ponkey->irq_dbr);
 	error = request_any_context_irq(ponkey->irq_dbr, ab8500_ponkey_handler,
 					0, "ab8500-ponkey-dbr", ponkey);
 	if (error < 0) {
-- 
1.7.9.5


--------------000203080400030203050104
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------000203080400030203050104--
