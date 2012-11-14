Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2KNGEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:04:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55069 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938Ab2KNFuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:25 -0500
Message-Id: <20121114053943.220056977@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zijie Pan <zijie.pan@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 68/82] sctp: fix call to SCTP_CMD_PROCESS_SACK in  sctp_cmd_interpreter()
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijie Pan <zijie.pan@6wind.com>

[ Upstream commit f6e80abeab928b7c47cc1fbf53df13b4398a2bec ]

Bug introduced by commit edfee0339e681a784ebacec7e8c2dc97dc6d2839
(sctp: check src addr when processing SACK to update transport state)

Signed-off-by: Zijie Pan <zijie.pan@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/sm_sideeffect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 76388b0..9032d50 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1604,8 +1604,9 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 					asoc->outqueue.outstanding_bytes;
 			sackh.num_gap_ack_blocks = 0;
 			sackh.num_dup_tsns = 0;
+			chunk->subh.sack_hdr = &sackh;
 			sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK,
-					SCTP_SACKH(&sackh));
+					SCTP_CHUNK(chunk));
 			break;
 
 		case SCTP_CMD_DISCARD_PACKET:


