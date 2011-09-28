Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1I1Wib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab1I1WiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:26 2011
Message-Id: <20110928220126.111607434@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nick Pelly <npelly@google.com>, "Govindraj.R" <govindraj.raja@ti.com>
Subject: [008/244] omap-serial: Allow IXON and IXOFF to be disabled.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Pelly <npelly@google.com>

commit b280a97d1caf6fe1d38b51ebb31219391f5ad1a0 upstream.

Fixes logic bug that software flow control cannot be disabled, because
serial_omap_configure_xonxoff() is not called if both IXON and IXOFF bits
are cleared.

Signed-off-by: Nick Pelly <npelly@google.com>
Acked-by: Govindraj.R <govindraj.raja@ti.com>
Tested-by: Govindraj.R <govindraj.raja@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/omap-serial.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -806,8 +806,7 @@ serial_omap_set_termios(struct uart_port
 
 	serial_omap_set_mctrl(&up->port, up->port.mctrl);
 	/* Software Flow Control Configuration */
-	if (termios->c_iflag & (IXON | IXOFF))
-		serial_omap_configure_xonxoff(up, termios);
+	serial_omap_configure_xonxoff(up, termios);
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
 	dev_dbg(up->port.dev, "serial_omap_set_termios+%d\n", up->pdev->id);


