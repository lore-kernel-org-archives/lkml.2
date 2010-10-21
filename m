Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab0JUKPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:15:41 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:36868 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754487Ab0JUKPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:15:39 -0400
Date: Thu, 21 Oct 2010 12:14:09 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sctp: remove redundant chunk length check
Message-ID: <20101021121409.6de7d429@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking the chunk length at this point appears redundant, as
the rest of the packet gets discarded anyway.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 net/sctp/sm_statefuns.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 4b4eb7c..9840615 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3418,12 +3418,6 @@ static sctp_disposition_t sctp_sf_shut_8_4_5(const struct sctp_endpoint *ep,
 
 		SCTP_INC_STATS(SCTP_MIB_OUTCTRLCHUNKS);
 
-		/* If the chunk length is invalid, we don't want to process
-		 * the reset of the packet.
-		 */
-		if (!sctp_chunk_length_valid(chunk, sizeof(sctp_chunkhdr_t)))
-			return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
-
 		/* We need to discard the rest of the packet to prevent
 		 * potential bomming attacks from additional bundled chunks.
 		 * This is documented in SCTP Threats ID.
-- 
1.7.2.2
