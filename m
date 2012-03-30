Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856Ab2C3XKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:10:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46720 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572Ab2C3VDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:03:54 -0400
Message-Id: <20120330195724.569810534@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 017/108] tty: moxa: fix bit test in moxa_start()
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 58112dfbfe02d803566a2c6c8bd97b5fa3c62cdc upstream.

This is supposed to be doing a shift before the comparison instead of
just doing a bitwise AND directly.  The current code means the start()
just returns without doing anything.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/moxa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1330,7 +1330,7 @@ static void moxa_start(struct tty_struct
 	if (ch == NULL)
 		return;
 
-	if (!(ch->statusflags & TXSTOPPED))
+	if (!test_bit(TXSTOPPED, &ch->statusflags))
 		return;
 
 	MoxaPortTxEnable(ch);


