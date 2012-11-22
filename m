Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab2KVVrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:47:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:49621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab2KVSkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Royer <nicolas@eukrea.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [ 16/83] ARM: at91/AT91SAM9G45: fix crypto peripherals irq issue due to sparse irq support
Date: Wed, 21 Nov 2012 16:41:38 -0800
Message-Id: <20121122004214.274250867@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Royer <nicolas@eukrea.com>

commit 097965ee447e5ccec9776f9b075e64cf7607e5eb upstream.

Spare irq support introduced by commit 8fe82a5 (ARM: at91: sparse irq support)
involves to add the NR_IRQS_LEGACY offset to irq number.

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric Bénard <eric@eukrea.com>
Tested-by: Eric Bénard <eric@eukrea.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/at91sam9g45_devices.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -1847,8 +1847,8 @@ static struct resource sha_resources[] =
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -1880,8 +1880,8 @@ static struct resource tdes_resources[]
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -1916,8 +1916,8 @@ static struct resource aes_resources[] =
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= AT91SAM9G45_ID_AESTDESSHA,
-		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
+		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_AESTDESSHA,
 		.flags	= IORESOURCE_IRQ,
 	},
 };


