Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148Ab0COO5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:57:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964955Ab0COO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:56:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [3/3] gigaset: prune use of tty_buffer_request_room
Date: Mon, 15 Mar 2010 14:48:05 -0000
To: Tilman Schmidt <tilman@imap.cc>
From: Karsten Keil <isdn@linux-pingi.de>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@vger.kernel.org,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       Hansjoerg Lipp <hjlipp@web.de>,
       i4ldeveloper <i4ldeveloper@listserv.isdn4linux.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-Id: <1268665009.25656@pingi>
X-Provags-ID: V01U2FsdGVkX1+le6qrdV5s2Y8sEKLp63xzyXEuACHw8TmaO47
 BkIo4dHpIWzq5XdZhQTChlzGF0IaZeU4/l3ggbyO6Cvpi5leVN
 zakWQuHOihcCn2kDpaIJ8geMXK4t+QB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling tty_buffer_request_room() before tty_insert_flip_string()
is unnecessary, costs CPU and for big buffers can mess up the
multi-page allocation avoidance.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <keil@b1-systems.de>

---
Note to -stable: applies correctly to 2.6.33 with fuzz 2.

 drivers/isdn/gigaset/interface.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index a1bcbc2..f0dc6c9 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -628,7 +628,6 @@ void gigaset_if_receive(struct cardstate *cs,
 	if (tty == NULL)
 		gig_dbg(DEBUG_IF, "receive on closed device");
 	else {
-		tty_buffer_request_room(tty, len);
 		tty_insert_flip_string(tty, buffer, len);
 		tty_flip_buffer_push(tty);
 	}
