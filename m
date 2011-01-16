Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab1APFQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 00:16:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46220 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab1APFQW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 00:16:22 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 16 Jan 2011 05:16:14 +0000
Message-ID: <1295154974.3693.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] 68360serial: Plumb in rs_360_get_icount()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0587102cf9f427c185bfdeb2cef41e13ee0264b1 replaced a direct
implementation of SIOCGICOUNT with an implementation of
tty_operations::get_icount, but it did not actually set
rs_360_ops.get_icount.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@kernel.org [2.6.37]
---
I have not even compiled this (it's an m68k-specific driver), but it
looks obvious enough.

Ben.

 drivers/serial/68360serial.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index e843b90..677a496 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -2428,6 +2428,7 @@ static const struct tty_operations rs_360_ops = {
 	/* .read_proc = rs_360_read_proc, */
 	.tiocmget = rs_360_tiocmget,
 	.tiocmset = rs_360_tiocmset,
+	.get_icount = rs_360_get_icount,
 };
 
 static int __init rs_360_init(void)
-- 
1.7.2.3


