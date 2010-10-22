Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab0JVTau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:30:50 -0400
Received: from kroah.org ([198.145.64.141]:41838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288Ab0JVSVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/49] serport: place serport serio device correctly in the device tree
Date: Fri, 22 Oct 2010 11:20:41 -0700
Message-Id: <1287771688-14805-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Make serport serio device to be a child of corresponding tty device
instead of just hanging at /sys/devices/serioX.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/serio/serport.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 6d34511..6e362de 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -165,6 +165,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	serio->open = serport_serio_open;
 	serio->close = serport_serio_close;
 	serio->port_data = serport;
+	serio->dev.parent = tty->dev;
 
 	serio_register_port(serport->serio);
 	printk(KERN_INFO "serio: Serial port %s\n", tty_name(tty, name));
-- 
1.7.2

