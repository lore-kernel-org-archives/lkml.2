Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2GTNdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:33:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40267 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2GTNdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:33:02 -0400
Date: Fri, 20 Jul 2012 16:32:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] tty: save newly allocated buffer in tty_free_termios()
Message-ID: <20120720133245.GD22245@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're trying to save the termios state and we need to allocate a buffer
to do it.  Smatch complains that the buffer is leaked at the end of the
function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index be18d60..58a1bdd 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1450,6 +1450,7 @@ void tty_free_termios(struct tty_struct *tty)
 			pr_warn("tty: no memory to save termios state.\n");
 			return;
 		}
+		tty->driver->termios[idx] = tp;
 	}
 	*tp = tty->termios;
 }
