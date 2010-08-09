Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0HIOXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:23:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39942 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab0HIOX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:23:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=j/3qwgIvsmyicLaZFckUjpIQTjdMCeUyMQVL1H+6bpFKxRzcD5ef4VvkEQErNECwrr
         AGKePBHizuKJKy6gJdz9dnebOkWOykBKxfG4GJ+kL7TN/kV7gm+chRlWfjXfSvnz32eZ
         rnuxStc+MfRrnaHqEzNNlPDtbnXv3UcwUwzcg=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/2] serport: place serport serio device correctly in the device tree
Date: Mon,  9 Aug 2010 18:22:50 +0400
Message-Id: <1281363770-23598-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281363770-23598-1-git-send-email-dbaryshkov@gmail.com>
References: <1281363770-23598-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make serport serio device to be a child of corresponding tty device
instead of just hanging at /sys/devices/serioX.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
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
1.7.1

