Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946268Ab2JDV1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:27:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42952 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946263Ab2JDV1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:27:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Samo Pogacnik <samo_pogacnik@t-2.net>
Subject: [ 12/33] TTY: ttyprintk, dont touch behind tty->write_buf
Date: Thu,  4 Oct 2012 14:26:34 -0700
Message-Id: <20121004210600.003061849@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210558.383865383@linuxfoundation.org>
References: <20121004210558.383865383@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit ee8b593affdf893012e57f4c54a21984d1b0d92e upstream.

If a user provides a buffer larger than a tty->write_buf chunk and
passes '\r' at the end of the buffer, we touch an out-of-bound memory.

Add a check there to prevent this.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Samo Pogacnik <samo_pogacnik@t-2.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ttyprintk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -66,7 +66,7 @@ static int tpk_printk(const unsigned cha
 				tmp[tpk_curr + 1] = '\0';
 				printk(KERN_INFO "%s%s", tpk_tag, tmp);
 				tpk_curr = 0;
-				if (buf[i + 1] == '\n')
+				if ((i + 1) < count && buf[i + 1] == '\n')
 					i++;
 				break;
 			case '\n':


