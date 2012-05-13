Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab2EMRud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 13:50:33 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49956 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751926Ab2EMRub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 13:50:31 -0400
Message-ID: <4FAFF473.7050000@xenotime.net>
Date: Sun, 13 May 2012 10:50:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Carlos Chinea <carlos.chinea@nokia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] hsi: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warnings in hsi files:

Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'e_handler' description in 'hsi_client'
Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'pclaimed' description in 'hsi_client'
Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'nb' description in 'hsi_client'
Warning(drivers/hsi/hsi.c:434): No description found for parameter 'handler'
Warning(drivers/hsi/hsi.c:434): Excess function parameter 'cb' description in 'hsi_register_port_event'

Don't document "private:" fields with kernel-doc notation.
If you want to leave them fully documented, that's OK, but
then don't mark them as "private:".

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Carlos Chinea <carlos.chinea@nokia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hsi/hsi.c       |    2 +-
 include/linux/hsi/hsi.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- lnx-34-rc7.orig/drivers/hsi/hsi.c
+++ lnx-34-rc7/drivers/hsi/hsi.c
@@ -420,7 +420,7 @@ static int hsi_event_notifier_call(struc
 /**
  * hsi_register_port_event - Register a client to receive port events
  * @cl: HSI client that wants to receive port events
- * @cb: Event handler callback
+ * @handler: Event handler callback
  *
  * Clients should register a callback to be able to receive
  * events from the ports. Registration should happen after
--- lnx-34-rc7.orig/include/linux/hsi/hsi.h
+++ lnx-34-rc7/include/linux/hsi/hsi.h
@@ -121,9 +121,9 @@ static inline int hsi_register_board_inf
  * @device: Driver model representation of the device
  * @tx_cfg: HSI TX configuration
  * @rx_cfg: HSI RX configuration
- * @e_handler: Callback for handling port events (RX Wake High/Low)
- * @pclaimed: Keeps tracks if the clients claimed its associated HSI port
- * @nb: Notifier block for port events
+ * e_handler: Callback for handling port events (RX Wake High/Low)
+ * pclaimed: Keeps tracks if the clients claimed its associated HSI port
+ * nb: Notifier block for port events
  */
 struct hsi_client {
 	struct device		device;
