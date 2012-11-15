Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767579Ab2KOER0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:17:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:50042 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993370Ab2KOENH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:13:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zijie Pan <zijie.pan@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/57] sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()
Date: Wed, 14 Nov 2012 20:11:45 -0800
Message-Id: <20121115040935.506609950@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Zijie Pan <zijie.pan@6wind.com>

[ Upstream commit f6e80abeab928b7c47cc1fbf53df13b4398a2bec ]

Bug introduced by commit edfee0339e681a784ebacec7e8c2dc97dc6d2839
(sctp: check src addr when processing SACK to update transport state)

Signed-off-by: Zijie Pan <zijie.pan@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1610,8 +1610,9 @@ static int sctp_cmd_interpreter(sctp_eve
 					asoc->outqueue.outstanding_bytes;
 			sackh.num_gap_ack_blocks = 0;
 			sackh.num_dup_tsns = 0;
+			chunk->subh.sack_hdr = &sackh;
 			sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK,
-					SCTP_SACKH(&sackh));
+					SCTP_CHUNK(chunk));
 			break;
 
 		case SCTP_CMD_DISCARD_PACKET:


