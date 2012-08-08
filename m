Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2HHPMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:12:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37523 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2HHPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:12:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND #2 2/3] tty: fix missing assignment
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 16:29:17 +0100
Message-ID: <20120808152808.8280.71771.stgit@localhost.localdomain>
In-Reply-To: <20120808152735.8280.54767.stgit@localhost.localdomain>
References: <20120808152735.8280.54767.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

We're trying to save the termios state and we need to allocate a buffer
to do it.  Smatch complains that the buffer is leaked at the end of the
function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/tty_io.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c6f4d71..6087499 100644
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

