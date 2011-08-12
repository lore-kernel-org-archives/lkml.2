Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1HLXji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 19:39:38 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22705 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1HLXjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 19:39:35 -0400
Date: Sat, 13 Aug 2011 01:39:43 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH][Trivial] net/wan/hdlc_ppp: remove dead goto
Message-ID: <alpine.LNX.2.00.1108130138100.7387@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

We'll either hit one of the case labels or the default in the switch
and in all cases do we then 'goto out', so having 'goto out' right
after the switch is pointless as we can never hit it - remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wan/hdlc_ppp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 055a918..5385876 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -547,7 +547,6 @@ static int ppp_rx(struct sk_buff *skb)
 		ppp_cp_event(dev, pid, RUC, 0, 0, len, cp);
 		goto out;
 	}
-	goto out;
 
 rx_error:
 	dev->stats.rx_errors++;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

