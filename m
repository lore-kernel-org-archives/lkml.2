Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1GHFBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:01:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1GHFBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:54 2011
Message-Id: <20110708001654.528913293@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [018/107] drivers/tty/serial/pch_uart.c: dont oops if dmi_get_system_info returns NULL
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Stein <alexander.stein@systec-electronic.com>

commit fb139dfeef9558a12ffdbf9e26951fd1a9304f3b upstream.

If dmi_get_system_info() returns NULL, pch_uart_init_port() will
dereferencea a zero pointer.

This oops was observed on an Atom based board which has no BIOS, but
a bootloder which doesn't provide DMI data.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/pch_uart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1392,6 +1392,7 @@ static struct eg20t_port *pch_uart_init_
 	int fifosize, base_baud;
 	int port_type;
 	struct pch_uart_driver_data *board;
+	const char *board_name;
 
 	board = &drv_dat[id->driver_data];
 	port_type = board->port_type;
@@ -1407,7 +1408,8 @@ static struct eg20t_port *pch_uart_init_
 	base_baud = 1843200; /* 1.8432MHz */
 
 	/* quirk for CM-iTC board */
-	if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+	board_name = dmi_get_system_info(DMI_BOARD_NAME);
+	if (board_name && strstr(board_name, "CM-iTC"))
 		base_baud = 192000000; /* 192.0MHz */
 
 	switch (port_type) {


