Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2ARGGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 01:06:24 -0500
Received: from relay03.digicable.hu ([92.249.128.185]:51270 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2ARGGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 01:06:23 -0500
Message-ID: <4F16611E.3050303@freemail.hu>
Date: Wed, 18 Jan 2012 07:05:18 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: PATCH] use void __iomem * pointers for ioread32()/iowrite32()
References: <4F12AB38.5040009@freemail.hu> <CACRpkdZ0osKrjTXsV96J5ckj=wC=OieHL7UTfjtm8ibHRuL6=A@mail.gmail.com> <4F153221.3080509@freemail.hu> <CACRpkdZEZ6X20mtP5reAq2UaG5f0DS_hMBN9L8LpV1O0tBkb-w@mail.gmail.com> <CACxGe6t2xtm-T43cBcbaqTrnPST9+R8E7dhq1rJnC+4P2__JRQ@mail.gmail.com>
In-Reply-To: <CACxGe6t2xtm-T43cBcbaqTrnPST9+R8E7dhq1rJnC+4P2__JRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 92.249.250.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The address pointer of ioread32()/iowrite32() functions are
of type "void __iomem *". Use matching variable type.

For details on __iomem see [1] and [2].

References:
[1] A new I/O memory access mechanism (Sep 15, 2004)
    http://lwn.net/Articles/102232/

[2] Being more anal about iospace accesses (Sep 15, 2004)
    http://lwn.net/Articles/102240/

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-pch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 68fa55e..84b7f28 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -231,7 +231,7 @@ static void pch_gpio_setup(struct pch_gpio *chip)
 static int pch_irq_type(struct irq_data *d, unsigned int type)
 {
 	u32 im;
-	u32 __iomem *im_reg;
+	void __iomem *im_reg;
 	u32 ien;
 	u32 im_pos;
 	int ch;
-- 
1.7.2.5


