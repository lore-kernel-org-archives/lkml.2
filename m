Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab2IGPix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:38:53 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:35189 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab2IGPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:38:51 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] serial: omap: fix compile breakage
Date: Fri,  7 Sep 2012 18:34:19 +0300
Message-Id: <1347032059-8901-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <20120907153136.GA8634@kroah.com>
References: <20120907153136.GA8634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when rebasing patches on top of Greg's tty-next,
it looks like automerge broke a few things which
I didn't catch (for whatever reason I didn't
have OMAP Serial enabled on .config) so I ended
up breaking the build on Greg's tty-next branch.

Fix the breakage by re-adding the three missing
members on struct uart_omap_port.

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---

Hi Greg,

I just fetched your tree again and rebased again just to
make sure. Everything is fine here, let me know if it
still applies with fuzz.

cheers

 arch/arm/plat-omap/include/plat/omap-serial.h | 4 ----
 drivers/tty/serial/omap-serial.c              | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index 3c9fd3e..a531149 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -105,8 +105,4 @@ struct uart_omap_dma {
 	unsigned int		rx_timeout;
 };
 
-
-	int			DTR_gpio;
-	int			DTR_inverted;
-	int			DTR_active;
 #endif /* __OMAP_SERIAL_H__ */
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index cfd2094..0a6e78e 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -100,6 +100,10 @@ struct uart_omap_port {
 	u8			wakeups_enabled;
 	unsigned int		irq_pending:1;
 
+	int			DTR_gpio;
+	int			DTR_inverted;
+	int			DTR_active;
+
 	struct pm_qos_request	pm_qos_request;
 	u32			latency;
 	u32			calc_latency;
-- 
1.7.12.rc3

