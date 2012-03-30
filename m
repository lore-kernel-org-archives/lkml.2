Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570Ab2C3V6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:58:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965600Ab2C3VSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:18:13 -0400
Message-Id: <20120330194830.310842692@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 030/175] tty: moxa: fix bit test in moxa_start()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1331,7 +1331,7 @@ static void moxa_start(struct tty_struct
 	if (ch == NULL)
 		return;
 
-	if (!(ch->statusflags & TXSTOPPED))
+	if (!test_bit(TXSTOPPED, &ch->statusflags))
 		return;
 
 	MoxaPortTxEnable(ch);


