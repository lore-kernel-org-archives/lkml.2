Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab0GAVr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:47:58 -0400
Received: from kroah.org ([198.145.64.141]:32780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759046Ab0GAVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:08 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:54 2010
Message-Id: <20100701174254.533112766@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Ungerer <gerg@uclinux.org>, Thiago Farina <tfransosi@gmail.com>
Subject: [096/200] m68knommu: fix broken use of BUAD_TABLE_SIZE in 68328serial driver
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Ungerer <gerg@snapgear.com>

commit e9a137cb00d8b0f71c08a9e67d993f53e7713d21 upstream.

Commit 8b505ca8e2600eb9e7dd2d6b2682a81717671374 ("serial: 68328serial.c:
remove BAUD_TABLE_SIZE macro") misses one use of BAUD_TABLE_SIZE.  So the
resulting 68328serial.c does not compile:

drivers/serial/68328serial.c: In function `m68328_console_setup':
drivers/serial/68328serial.c:1439: error: `BAUD_TABLE_SIZE' undeclared (first use in this function)
drivers/serial/68328serial.c:1439: error: (Each undeclared identifier is reported only once
drivers/serial/68328serial.c:1439: error: for each function it appears in.)

Fix that last use of it.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Cc: Thiago Farina <tfransosi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/68328serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -1437,7 +1437,7 @@ int m68328_console_setup(struct console
 	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == n)
 			break;
-	if (i < BAUD_TABLE_SIZE) {
+	if (i < ARRAY_SIZE(baud_table)) {
 		m68328_console_baud = n;
 		m68328_console_cbaud = 0;
 		if (i > 15) {


