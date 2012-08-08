Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab2HHPM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:12:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37528 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2HHPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:12:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND #2 3/3] tty: handle NULL parameters in free_tty_struct()
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 16:29:43 +0100
Message-ID: <20120808152929.8280.68104.stgit@localhost.localdomain>
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

We sometimes pass NULL pointers to free_tty_struct().  One example where
it can happen is in the error handling code in pty_common_install().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---

 drivers/tty/tty_io.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 6087499..6784aae 100644
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

