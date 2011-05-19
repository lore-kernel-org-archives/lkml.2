Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab1ESSRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:17:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33806 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934026Ab1ESSIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:43 -0400
X-Sasl-enc: t/k5ZlRUh4Rrc6/mEnczDzgfhywG7cG1jBu9CQpK4CmS 1305828522
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:58 2011
Message-Id: <20110519180557.956623044@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [38/71] slcan: fix ldisc->open retval
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 0d4420a90b51abdea71585f571bad6d789ff8eb7 upstream.

TTY layer expects 0 if the ldisc->open operation succeeded.

Reported-by: Matvejchikov Ilya <matvejchikov@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/can/slcan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -583,7 +583,9 @@ static int slcan_open(struct tty_struct
 	/* Done.  We have linked the TTY line to a channel. */
 	rtnl_unlock();
 	tty->receive_room = 65536;	/* We don't flow control */
-	return sl->dev->base_addr;
+
+	/* TTY layer expects 0 on success */
+	return 0;
 
 err_free_chan:
 	sl->tty = NULL;


