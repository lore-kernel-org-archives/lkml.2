Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1DSURM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:12 -0400
Received: from kroah.org ([198.145.64.141]:47654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab1DSURH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201045.607760009@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Siemon <dan@coverfire.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        =?ISO-8859-15?q?Dave=20T=C3=A4ht?= <d@taht.net>,
        Jonathan Morton <chromatix99@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [23/70] net_sched: fix ip_tos2prio
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Dan Siemon <dan@coverfire.com>

[ Upstream commit 4a2b9c3756077c05dd8666e458a751d2248b61b6 ]

ECN support incorrectly maps ECN BESTEFFORT packets to TC_PRIO_FILLER
(1) instead of TC_PRIO_BESTEFFORT (0)

This means ECN enabled flows are placed in pfifo_fast/prio low priority
band, giving ECN enabled flows [ECT(0) and CE codepoints] higher drop
probabilities.

This is rather unfortunate, given we would like ECN being more widely
used.

Ref : http://www.coverfire.com/archives/2011/03/13/pfifo_fast-and-ecn/

Signed-off-by: Dan Siemon <dan@coverfire.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Täht <d@taht.net>
Cc: Jonathan Morton <chromatix99@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -171,7 +171,7 @@ static struct dst_ops ipv4_dst_ops = {
 
 const __u8 ip_tos2prio[16] = {
 	TC_PRIO_BESTEFFORT,
-	ECN_OR_COST(FILLER),
+	ECN_OR_COST(BESTEFFORT),
 	TC_PRIO_BESTEFFORT,
 	ECN_OR_COST(BESTEFFORT),
 	TC_PRIO_BULK,


