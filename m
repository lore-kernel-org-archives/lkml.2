Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2AQUow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:44:52 -0500
Received: from relay03.digicable.hu ([92.249.128.185]:44668 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2AQUov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:44:51 -0500
Message-ID: <4F15DD7E.4070405@freemail.hu>
Date: Tue, 17 Jan 2012 21:43:42 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2 v2] gpio-pch: cleanup __iomem annotation usage
References: <4F12AB38.5040009@freemail.hu>	<CACRpkdZ0osKrjTXsV96J5ckj=wC=OieHL7UTfjtm8ibHRuL6=A@mail.gmail.com>	<4F153221.3080509@freemail.hu> <CACRpkdZEZ6X20mtP5reAq2UaG5f0DS_hMBN9L8LpV1O0tBkb-w@mail.gmail.com>
In-Reply-To: <CACRpkdZEZ6X20mtP5reAq2UaG5f0DS_hMBN9L8LpV1O0tBkb-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 94.21.187.250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The __iomem annotation is to be used together with pointers used
as iowrite32() parameter. For more details see [1] and [2].

This patch will remove the following sparse warnings ("make C=1"):
 * warning: incorrect type in assignment (different address spaces)
 * warning: incorrect type in argument 1 (different address spaces)
 * warning: incorrect type in argument 2 (different address spaces)

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
index f060329..8f101b3 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -231,7 +231,7 @@ static void pch_gpio_setup(struct pch_gpio *chip)
 static int pch_irq_type(struct irq_data *d, unsigned int type)
 {
 	u32 im;
-	u32 *im_reg;
+	void __iomem *im_reg;
 	u32 ien;
 	u32 im_pos;
 	int ch;
-- 
1.7.2.5
