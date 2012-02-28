Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030249Ab2B1SvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:51:14 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47407 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966054Ab2B1SvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:51:12 -0500
From: Joe Perches <joe@perches.com>
To: Felipe Balbi <balbi@ti.com>, Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 9/9] gadget: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:38 -0800
Message-Id: <1bc7879deffd667985a3bcfce70e19418c704143.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the function name not the address when possible.

builtin_return_address() gives an address.  When building
a kernel with CONFIG_KALLSYMS, emit the actual function
name not the address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/gadget/u_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 6597a68..a553bee 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -920,7 +920,7 @@ static int gs_put_char(struct tty_struct *tty, unsigned char ch)
 	unsigned long	flags;
 	int		status;
 
-	pr_vdebug("gs_put_char: (%d,%p) char=0x%x, called from %p\n",
+	pr_vdebug("gs_put_char: (%d,%p) char=0x%x, called from %pf\n",
 		port->port_num, tty, ch, __builtin_return_address(0));
 
 	spin_lock_irqsave(&port->port_lock, flags);
-- 
1.7.8.111.gad25c.dirty

