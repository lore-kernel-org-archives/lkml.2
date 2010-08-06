Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591Ab0HFQaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:30:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50273 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761304Ab0HFQ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e03ehFHWebxEZgDGtbCoUtXhrFQZd8O2JbcgLCXAWWtwSXwj/zyTDbzcXQ24LCVY3+
         +MxnDfzavHN2H4PapPU69K9FpEVOi5XnWQbhdScwwfDI+E7dN5vIu+uSKLlbwAH3YYC+
         XspXHxkKcDmZW9/OyS6gdfobZ9VCw354yz7LM=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] serport: place serport serio device correctly in the device tree
Date: Fri,  6 Aug 2010 20:29:29 +0400
Message-Id: <1281112169-27086-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281112169-27086-1-git-send-email-dbaryshkov@gmail.com>
References: <1281112169-27086-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make serport serio device to be a child of corresponding tty device
instead of just hanging at /sys/devices/serioX.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/input/serio/serport.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 6d34511..ee0ff0c 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -165,6 +165,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	serio->open = serport_serio_open;
 	serio->close = serport_serio_close;
 	serio->port_data = serport;
+	serio->dev.parent = tty_get_device(tty);
 
 	serio_register_port(serport->serio);
 	printk(KERN_INFO "serio: Serial port %s\n", tty_name(tty, name));
-- 
1.7.1

