Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1CAFJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:09:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42774 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1CAFJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:09:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lRB7si6kig9wXBZ3qUhKfMe8USl9cl0G7zWoce2UL+U5leQ5mBQJf8kFkPJ8barXxs
         PefAEENy6yCCVJLmjQVb6EXCKGcE0T9nz4sqYY5uRxG6iePDAtCzzn3QLszORKKLKUWU
         JoIOtQeGUh5DBR9/znnmG7cf0WiIm082zUVkg=
Subject: [PATCH] pcmcia: synclink_cs: fix prototype for mgslpc_ioctl()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain
Date: Tue, 01 Mar 2011 13:12:47 +0800
Message-Id: <1298956367.24263.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl file pointer was removed in commit 6caa76
"tty: now phase out the ioctl file pointer for good".

Thus fix the prototype for mgslpc_ioctl() and eliminate below warning:
  CC [M]  drivers/char/pcmcia/synclink_cs.o
drivers/char/pcmcia/synclink_cs.c:2787: warning: initialization from incompatible pointer type

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/char/pcmcia/synclink_cs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 02127ca..beca80b 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2222,13 +2222,12 @@ static int mgslpc_get_icount(struct tty_struct *tty,
  * Arguments:
  *
  * 	tty	pointer to tty instance data
- * 	file	pointer to associated file object for device
  * 	cmd	IOCTL command code
  * 	arg	command argument/context
  *
  * Return Value:	0 if success, otherwise error code
  */
-static int mgslpc_ioctl(struct tty_struct *tty, struct file * file,
+static int mgslpc_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
-- 
1.7.2



