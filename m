Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0G1SaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:30:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38828 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755798Ab0G1SaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:30:00 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/2VEp/vU324AOra360hO+/OB1Fn9wpIvnqcLA/b4
	XzOW9Sqy0IbJLN
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH] video/w100fb: ignore void return value / fix build failure
Date: Wed, 28 Jul 2010 20:29:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaya Kumar <jayakumar.lkml@gmail.com>,
        Henrik Kretzschmar <henne@nachtwindheim.de>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007282029.52989.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure [1] (error: void value not ignored as
it ought to be) by removing an assignment of a void return value.
The functionality of the code is not changed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100728
References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2980912/

 drivers/video/w100fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index e66b8b1..d8b12c3 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -858,9 +858,9 @@ unsigned long w100fb_gpio_read(int port)
 void w100fb_gpio_write(int port, unsigned long value)
 {
 	if (port==W100_GPIO_PORT_A)
-		value = writel(value, remapped_regs + mmGPIO_DATA);
+		writel(value, remapped_regs + mmGPIO_DATA);
 	else
-		value = writel(value, remapped_regs + mmGPIO_DATA2);
+		writel(value, remapped_regs + mmGPIO_DATA2);
 }
 EXPORT_SYMBOL(w100fb_gpio_read);
 EXPORT_SYMBOL(w100fb_gpio_write);
-- 
1.7.1

