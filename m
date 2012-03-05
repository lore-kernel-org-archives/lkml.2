Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab2CEN6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:58:08 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34828 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964773Ab2CENxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 21/68] TTY: serial, use atomic_inc_return in ioc4_serial
Date: Mon,  5 Mar 2012 14:52:08 +0100
Message-Id: <1330955575-26641-22-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to know the value of the atomic variable in intr_connect after
the increment. But atomic_inc doesn't, per definition, return the
value.  It is just a pure coincidence that ia64 defines atomic_inc as
atomic_inc_return.

So fix this mistake by using atomic_inc_return properly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/ioc4_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index 6b36c15..dfec69a 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -975,7 +975,7 @@ intr_connect(struct ioc4_soft *soft, int type,
 	BUG_ON(!((type == IOC4_SIO_INTR_TYPE)
 	       || (type == IOC4_OTHER_INTR_TYPE)));
 
-	i = atomic_inc(&soft-> is_intr_type[type].is_num_intrs) - 1;
+	i = atomic_inc_return(&soft-> is_intr_type[type].is_num_intrs) - 1;
 	BUG_ON(!(i < MAX_IOC4_INTR_ENTS || (printk("i %d\n", i), 0)));
 
 	/* Save off the lower level interrupt handler */
-- 
1.7.9.2


