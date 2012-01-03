Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2ACWe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:34:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab2ACWe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:34:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:31 2012
Message-Id: <20120103223031.354743448@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [01/67] ARM: OMAP: rx51: fix USB
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Contreras <felipe.contreras@gmail.com>

commit e5fe29c7198a1f6616286dfc8602a69da165cb3f upstream.

Commit 10299e2e4e3ed3b16503d4e04edd48b33083f4e2 (ARM: RX-51:
Enable isp1704 power on/off) added power management for isp1704.

However, the transceiver should be powered on by default,
otherwise USB doesn't work at all for networking during
boot.

All kernels after v3.0 are affected.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Reviewed-by: Sebastian Reichel <sre@debian.org>
[tony@atomide.com: updated comments]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -133,7 +133,7 @@ static struct platform_device rx51_charg
 static void __init rx51_charger_init(void)
 {
 	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
-		GPIOF_OUT_INIT_LOW, "isp1704_reset"));
+		GPIOF_OUT_INIT_HIGH, "isp1704_reset"));
 
 	platform_device_register(&rx51_charger_device);
 }


