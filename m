Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2JQGNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:13:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44481 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab2JQGNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:13:32 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: discrepancy while save and restore of debounce registers
Thread-Topic: discrepancy while save and restore of debounce registers
Thread-Index: Ac2sLoK1QcZgBYyrRUCfh4cWp+znkw==
Date: Wed, 17 Oct 2012 06:13:25 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EAA9A7C@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9H6DbNR002341

Hi,

I came across a peculiar issue while updating GPIO debounce registers on
OMAP platform.

According to mainline commit ae547354a8ed59f19b57f7e1de9c7816edfc3537

gpio/omap: save and restore debounce registers

GPIO debounce registers need to be saved and restored for proper functioning
of driver.

...
@@ -1363,6 +1369,12 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
        __raw_writel(bank->context.fallingdetect,
                                bank->base + bank->regs->fallingdetect);
        __raw_writel(bank->context.dataout, bank->base + bank->regs->dataout);
+       if (bank->dbck_enable_mask) {
+               __raw_writel(bank->context.debounce, bank->base +
+                                       bank->regs->debounce);
+               __raw_writel(bank->context.debounce_en,
+                                       bank->base + bank->regs->debounce_en);
+       }
 }


Due to copy/paste of this commit into my local tree, I missed the check for 
bank->dbck_enable_mask, and directly restored the saved value from context.

After this, I saw random crashes when accessing different registers (sometimes
its OE register and sometime its DATAOUT register). 

These crashes were seen across 2nd and subsequent suspend/resume.

My doubt/questions are
1. Why should debounce registers be updated only when it's accessed previously?

2. What is the relation between updating debounce registers and crash seen on
others registers? 

Thanks in advance for the support.

Regards
Gururaja


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
