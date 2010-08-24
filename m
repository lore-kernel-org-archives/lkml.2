Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0HXE02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:26:28 -0400
Received: from kroah.org ([198.145.64.141]:56420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab0HXEYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/6] ip2: remove unneeded NULL check
Date: Mon, 23 Aug 2010 21:24:02 -0700
Message-Id: <1282623846-17050-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040508.GC16749@kroah.com>
References: <20100824040508.GC16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

We don't pass NULL tty pointers to the close function, and anyway we
already dereferenced it at this point.  This check can be removed.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: "Michael H. Warfield" <mhw@wittsend.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/ip2/ip2main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 07f3ea3..8fa041e 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -1650,7 +1650,7 @@ ip2_close( PTTY tty, struct file *pFile )
 	/* disable DSS reporting */
 	i2QueueCommands(PTYPE_INLINE, pCh, 100, 4,
 				CMD_DCD_NREP, CMD_CTS_NREP, CMD_DSR_NREP, CMD_RI_NREP);
-	if ( !tty || (tty->termios->c_cflag & HUPCL) ) {
+	if (tty->termios->c_cflag & HUPCL) {
 		i2QueueCommands(PTYPE_INLINE, pCh, 100, 2, CMD_RTSDN, CMD_DTRDN);
 		pCh->dataSetOut &= ~(I2_DTR | I2_RTS);
 		i2QueueCommands( PTYPE_INLINE, pCh, 100, 1, CMD_PAUSE(25));
-- 
1.7.2

