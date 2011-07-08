Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1GHFGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:06:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab1GHFGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:06:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001702.832763639@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [104/107] xfrm: Fix off by one in the replay advance functions
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit e756682c8baa47da1648c0c016e9f48ed66bc32d ]

We may write 4 byte too much when we reinitialize the anti replay
window in the replay advance functions. This patch fixes this by
adjusting the last index of the initialization loop.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/xfrm/xfrm_replay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -265,7 +265,7 @@ static void xfrm_replay_advance_bmp(stru
 			bitnr = bitnr & 0x1F;
 			replay_esn->bmp[nr] |= (1U << bitnr);
 		} else {
-			nr = replay_esn->replay_window >> 5;
+			nr = (replay_esn->replay_window - 1) >> 5;
 			for (i = 0; i <= nr; i++)
 				replay_esn->bmp[i] = 0;
 
@@ -471,7 +471,7 @@ static void xfrm_replay_advance_esn(stru
 			bitnr = bitnr & 0x1F;
 			replay_esn->bmp[nr] |= (1U << bitnr);
 		} else {
-			nr = replay_esn->replay_window >> 5;
+			nr = (replay_esn->replay_window - 1) >> 5;
 			for (i = 0; i <= nr; i++)
 				replay_esn->bmp[i] = 0;
 


