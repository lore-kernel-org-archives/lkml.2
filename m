Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1GLUn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:43:28 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:57733 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1GLUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:43:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/3] TTY: msm_serial, remove unneeded console set
Date: Tue, 12 Jul 2011 22:43:19 +0200
Message-Id: <1310503400-28447-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310503400-28447-1-git-send-email-jslaby@suse.cz>
References: <1310503400-28447-1-git-send-email-jslaby@suse.cz>
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


