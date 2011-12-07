Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1LGMuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:50:54 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47734 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab1LGMux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:50:53 -0500
MIME-Version: 1.0
In-Reply-To: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
Date: Wed, 7 Dec 2011 13:50:52 +0100
Message-ID: <CACRpkdaR1Z982eqvF777_kvRg1YVMxC6r=vqVMFovYah_w9Dyw@mail.gmail.com>
Subject: Re: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE modem
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order not to cause build troubles I had to apply this patch:

>From 429471bfdc25b4773e157bb2aca02cb0033c824b Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 7 Dec 2011 13:45:52 +0100
Subject: [PATCH] Fixup build by default-building dummy genio

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/xshm/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xshm/Makefile b/drivers/xshm/Makefile
index 954bd22..9670960 100644
--- a/drivers/xshm/Makefile
+++ b/drivers/xshm/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_XSHM) += xshm.o
-xshm-objs := xshm_boot.o xshm_dev.o
+xshm-objs := xshm_boot.o xshm_dev.o genio_dummy.o
 obj-$(CONFIG_XSHM_CHR) +=  xshm_chr.o
-- 
1.7.3.2

I think that you need to teach the driver to dynamically look
for a genio driver so you don't get compilation errors,
then it will find any genio driver or the dummy driver if that
is compiled in.

At the least you need a Kconfig and Makefile entry for the
dummy_genio driver...

Yours,
Linus Walleij
