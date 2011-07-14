Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1GNMfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:35:23 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51358 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1GNMfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:35:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH v2 2/6] TTY: msm_serial, remove unneeded console set
Date: Thu, 14 Jul 2011 14:35:11 +0200
Message-Id: <1310646915-3032-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make sense to set console to uart_port in console->setup.
At that time the console is set by uart_add_one_port already.

The call chain looked like:
uart_add_one_port()
  uport->cons = drv->cons;   <= once
  uart_configure_port()
    register_console()
     console->setup()
       port->cons = co;      <= second time

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/msm_serial.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index e6ba838..29cbfd8 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -804,8 +804,6 @@ static int __init msm_console_setup(struct console *co, char *options)
 	if (unlikely(!port->membase))
 		return -ENXIO;
 
-	port->cons = co;
-
 	msm_init_clock(port);
 
 	if (options)
-- 
1.7.6


