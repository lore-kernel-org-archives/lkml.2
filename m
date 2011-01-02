Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1ABHsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:48:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:36035 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab1ABHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 151/260] sctp: Do not reset the packet during sctp_packet_config().
Date: Sun,  2 Jan 2011 02:17:27 -0500
Message-Id: <1293952756-15010-152-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:56.0384 (UTC) FILETIME=[E060E000:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>

commit 4bdab43323b459900578b200a4b8cf9713ac8fab upstream.

sctp_packet_config() is called when getting the packet ready
for appending of chunks.  The function should not touch the
current state, since it's possible to ping-pong between two
transports when sending, and that can result packet corruption
followed by skb overlfow crash.

Reported-by: Thomas Dreibholz <dreibh@iem.uni-due.de>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sctp/output.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index fad261d..5468d41 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -92,7 +92,6 @@ struct sctp_packet *sctp_packet_config(struct sctp_packet *packet,
 	SCTP_DEBUG_PRINTK("%s: packet:%p vtag:0x%x\n", __func__,
 			  packet, vtag);
 
-	sctp_packet_reset(packet);
 	packet->vtag = vtag;
 
 	if (ecn_capable && sctp_packet_empty(packet)) {
-- 
1.7.3.3

