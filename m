Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2JNPQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:16:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46070 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab2JNOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:37 -0400
Message-Id: <20121014143534.477002986@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Samo Pogacnik <samo_pogacnik@t-2.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 005/147] TTY: ttyprintk, dont touch behind tty->write_buf
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit ee8b593affdf893012e57f4c54a21984d1b0d92e upstream.

If a user provides a buffer larger than a tty->write_buf chunk and
passes '\r' at the end of the buffer, we touch an out-of-bound memory.

Add a check there to prevent this.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Samo Pogacnik <samo_pogacnik@t-2.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


