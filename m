Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2CBGtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:49:21 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:47526 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2CBGtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:49:19 -0500
Date: Fri, 2 Mar 2012 09:49:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] tty: cyclades: clean up a type issue
Message-ID: <20120302064908.GA24508@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F506D6C.0090,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of casting value to unsigned long when we use it, we can just
declare it that way at the start.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index c9bf779..fbca4ee 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -2397,7 +2397,7 @@ check_and_exit:
  *	    transmit holding register is empty.  This functionality
  *	    allows an RS485 driver to be written in user space.
  */
-static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
+static int get_lsr_info(struct cyclades_port *info, unsigned long __user *value)
 {
 	struct cyclades_card *card = info->card;
 	unsigned int result;
@@ -2413,7 +2413,7 @@ static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
 		/* Not supported yet */
 		return -EINVAL;
 	}
-	return put_user(result, (unsigned long __user *)value);
+	return put_user(result, value);
 }
 
 static int cy_tiocmget(struct tty_struct *tty)
