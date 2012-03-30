Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457Ab2C3VQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:16:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53985 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965443Ab2C3VQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:16:14 -0400
Message-Id: <20120330194903.490081718@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 142/149] xfrm: Access the replay notify functions via the registered callbacks
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 1265fd616782ef03b98fd19f65c2b47fcd4ea11f ]

We call the wrong replay notify function when we use ESN replay
handling. This leads to the fact that we don't send notifications
if we use ESN. Fix this by calling the registered callbacks instead
of xfrm_replay_notify().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_replay.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -167,7 +167,7 @@ static void xfrm_replay_advance(struct x
 	}
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
+		x->repl->notify(x, XFRM_REPLAY_UPDATE);
 }
 
 static int xfrm_replay_overflow_bmp(struct xfrm_state *x, struct sk_buff *skb)
@@ -279,7 +279,7 @@ static void xfrm_replay_advance_bmp(stru
 	replay_esn->bmp[nr] |= (1U << bitnr);
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
+		x->repl->notify(x, XFRM_REPLAY_UPDATE);
 }
 
 static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
@@ -473,7 +473,7 @@ static void xfrm_replay_advance_esn(stru
 	replay_esn->bmp[nr] |= (1U << bitnr);
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
+		x->repl->notify(x, XFRM_REPLAY_UPDATE);
 }
 
 static struct xfrm_replay xfrm_replay_legacy = {


