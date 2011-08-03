Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab1HCXeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:34:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab1HCXap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:52 2011
Message-Id: <20110803221252.820068993@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>
Subject: [087/102] tty/serial: Fix XSCALE serial ports, e.g. ce4100
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 5568181f188ae9485a0cdbea5ea48f63d186a298 upstream.

Commit 4539c24fe4f92c09ee668ef959d3e8180df619b9 "tty/serial: Add
explicit PORT_TEGRA type" introduced separate flags describing the need
for IER bits UUE and RTOIE. Both bits are required for the XSCALE port
type. While that patch updated uart_config[] as required, the auto-probing
code wasn't updated to set the RTOIE flag when an XSCALE port type was
detected. This caused such ports to stop working. This patch rectifies
that.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/8250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1107,7 +1107,7 @@ static void autoconfig_16550a(struct uar
 			 */
 			DEBUG_AUTOCONF("Xscale ");
 			up->port.type = PORT_XSCALE;
-			up->capabilities |= UART_CAP_UUE;
+			up->capabilities |= UART_CAP_UUE | UART_CAP_RTOIE;
 			return;
 		}
 	} else {


