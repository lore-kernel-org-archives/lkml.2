Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab1ESScg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:32:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48448 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934356Ab1ESSce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:34 -0400
X-Sasl-enc: kpTJ4L2LFbb0aTxx0wqXaolbC+7XHBIKFXdbrNa4YHNx 1305829953
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:26 2011
Message-Id: <20110519183126.506284585@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Alan Cox <alan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [09/24] NET: slip, fix ldisc->open retval
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 875
Lines: 30

From: Matvejchikov Ilya <matvejchikov@gmail.com>

commit 057bef938896e6266ae24ec4266d24792d27c29a upstream.

TTY layer expects 0 if the ldisc->open operation succeeded.

Signed-off-by : Matvejchikov Ilya <matvejchikov@gmail.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/slip.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -851,7 +851,9 @@ static int slip_open(struct tty_struct *
 	/* Done.  We have linked the TTY line to a channel. */
 	rtnl_unlock();
 	tty->receive_room = 65536;	/* We don't flow control */
-	return sl->dev->base_addr;
+
+	/* TTY layer expects 0 on success */
+	return 0;
 
 err_free_bufs:
 	sl_free_bufs(sl);


