Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1HUViP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 17:38:15 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21662 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1HUViN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 17:38:13 -0400
Date: Sun, 21 Aug 2011 23:38:51 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Miller <davem@davemloft.net>
cc: khc@pm.waw.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH][Trivial] net/wan/hdlc_ppp: remove dead goto
In-Reply-To: <20110818.220249.1523360015062657902.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1108212337380.8097@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108130138100.7387@swampdragon.chaosbits.net> <20110818.220249.1523360015062657902.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, David Miller wrote:

> From: Jesper Juhl <jj@chaosbits.net>
> Date: Sat, 13 Aug 2011 01:39:43 +0200 (CEST)
> 
> > From: Jesper Juhl <jj@chaosbits.net>
> > 
> > We'll either hit one of the case labels or the default in the switch
> > and in all cases do we then 'goto out', so having 'goto out' right
> > after the switch is pointless as we can never hit it - remove it.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Probably a lot cleaner to use break statements in the switch() statement
> and keep this goto in place.
> 
> That's more straightforward control flow than what this thing is doing.

Here you are :)


From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] net/wan/hdlc_ppp: use break in switch

We'll either hit one of the case labels or the default in the switch
and in all cases do we then 'goto out' and we also have a 'goto out'
after the switch that is redundant. Change to just use break in the
case statements and leave the 'goto out' after the lop for everyone to
hit.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wan/hdlc_ppp.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 055a918..0d76455 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -515,37 +515,37 @@ static int ppp_rx(struct sk_buff *skb)
 	switch (cp->code) {
 	case CP_CONF_REQ:
 		ppp_cp_parse_cr(dev, pid, cp->id, len, skb->data);
-		goto out;
+		break;
 
 	case CP_CONF_ACK:
 		if (cp->id == proto->cr_id)
 			ppp_cp_event(dev, pid, RCA, 0, 0, 0, NULL);
-		goto out;
+		break;
 
 	case CP_CONF_REJ:
 	case CP_CONF_NAK:
 		if (cp->id == proto->cr_id)
 			ppp_cp_event(dev, pid, RCN, 0, 0, 0, NULL);
-		goto out;
+		break;
 
 	case CP_TERM_REQ:
 		ppp_cp_event(dev, pid, RTR, 0, cp->id, 0, NULL);
-		goto out;
+		break;
 
 	case CP_TERM_ACK:
 		ppp_cp_event(dev, pid, RTA, 0, 0, 0, NULL);
-		goto out;
+		break;
 
 	case CP_CODE_REJ:
 		ppp_cp_event(dev, pid, RXJ_BAD, 0, 0, 0, NULL);
-		goto out;
+		break;
 
 	default:
 		len += sizeof(struct cp_header);
 		if (len > dev->mtu)
 			len = dev->mtu;
 		ppp_cp_event(dev, pid, RUC, 0, 0, len, cp);
-		goto out;
+		break;
 	}
 	goto out;
 
-- 
1.7.6



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

