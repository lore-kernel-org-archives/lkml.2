Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab2BAVIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:08:52 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43355 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757133Ab2BAVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:48 -0500
X-Sasl-enc: c9s4dcB3MDaxH+4vvk628KWDpGG8kHryLqpEElbouTYp 1328130527
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:38 2012
Message-Id: <20120201205738.802311246@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:55:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nick Bowler <nbowler@elliptictech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [15/65] ah: Dont return NET_XMIT_DROP on input.
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Bowler <nbowler@elliptictech.com>

commit 4b90a603a1b21d63cf743cc833680cb195a729f6 upstream.

When the ahash driver returns -EBUSY, AH4/6 input functions return
NET_XMIT_DROP, presumably copied from the output code path.  But
returning transmit codes on input doesn't make a lot of sense.
Since NET_XMIT_DROP is a positive int, this gets interpreted as
the next header type (i.e., success).  As that can only end badly,
remove the check.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ah4.c |    2 --
 net/ipv6/ah6.c |    2 --
 2 files changed, 4 deletions(-)

--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -369,8 +369,6 @@ static int ah_input(struct xfrm_state *x
 		if (err == -EINPROGRESS)
 			goto out;
 
-		if (err == -EBUSY)
-			err = NET_XMIT_DROP;
 		goto out_free;
 	}
 
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -581,8 +581,6 @@ static int ah6_input(struct xfrm_state *
 		if (err == -EINPROGRESS)
 			goto out;
 
-		if (err == -EBUSY)
-			err = NET_XMIT_DROP;
 		goto out_free;
 	}
 


