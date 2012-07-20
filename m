Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2GTHGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:06:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45362 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2GTHGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:06:43 -0400
Date: Fri, 20 Jul 2012 10:06:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] tty: handle NULL parameters in free_tty_struct()
Message-ID: <20120720070634.GC11710@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We sometimes pass NULL pointers to free_tty_struct().  One example where
it can happen is in the error handling code in pty_common_install().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index ca7c25d..e49b839 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -181,6 +181,8 @@ struct tty_struct *alloc_tty_struct(void)
 
 void free_tty_struct(struct tty_struct *tty)
 {
+	if (!tty)
+		return;
 	if (tty->dev)
 		put_device(tty->dev);
 	kfree(tty->write_buf);
