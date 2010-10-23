Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0JWTMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:12:41 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:50168 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758819Ab0JWTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:12:40 -0400
Date: Sat, 23 Oct 2010 21:11:29 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Andreas Koensgen <ajk@comnets.uni-bremen.de>
Cc: linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 6pack: remove duplicated packet size check
Message-ID: <20101023211129.50d07640@absol.kitzblitz>
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

Packet size is checked twice in a row.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/net/hamradio/6pack.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 3e5d0b6..bf71742 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -172,11 +172,6 @@ static void sp_encaps(struct sixpack *sp, unsigned char *icp, int len)
 		goto out_drop;
 	}
 
-	if (len > sp->mtu) {	/* sp->mtu = AX25_MTU = max. PACLEN = 256 */
-		msg = "oversized transmit packet!";
-		goto out_drop;
-	}
-
 	if (p[0] > 5) {
 		msg = "invalid KISS command";
 		goto out_drop;
-- 
1.7.2.2
