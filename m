Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2HGUBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:01:38 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36552 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2HGT7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:46 -0400
X-Greylist: delayed 692 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 15:59:46 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        stable@vger.kernel.org (everything maintained past v2.6.37),
        Samo Pogacnik <samo_pogacnik@t-2.net>
Subject: [PATCH 14/41] TTY: ttyprintk, don't touch behind tty->write_buf
Date: Tue,  7 Aug 2012 21:47:39 +0200
Message-Id: <1344368886-24033-15-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a user provides a buffer larger than a tty->write_buf chunk and
passes '\r' at the end of the buffer, we touch an out-of-bound memory.

Add a check there to prevent this.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org (everything maintained past v2.6.37)
Cc: Samo Pogacnik <samo_pogacnik@t-2.net>
---
 drivers/char/ttyprintk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index 9b1e5e0..08755c5 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -67,7 +67,7 @@ static int tpk_printk(const unsigned char *buf, int count)
 				tmp[tpk_curr + 1] = '\0';
 				printk(KERN_INFO "%s%s", tpk_tag, tmp);
 				tpk_curr = 0;
-				if (buf[i + 1] == '\n')
+				if ((i + 1) < count && buf[i + 1] == '\n')
 					i++;
 				break;
 			case '\n':
-- 
1.7.10.4


