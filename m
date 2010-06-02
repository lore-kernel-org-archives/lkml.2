Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab0FBPFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:05:14 -0400
Received: from mail.netservers.co.uk ([80.248.178.71]:47630 "EHLO
	mail.netservers.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382Ab0FBPFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:05:12 -0400
X-Envelope-From: ben@netservers.co.uk
From: Ben McKeegan <ben@netservers.co.uk>
To: davem@davemloft.net
Cc: ben@netservers.co.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       gabriele.paoloni@intel.com, alan@lxorguk.ukuu.org.uk,
       linux-ppp@vger.kernel.org, paulus@samba.org
Subject: [PATCH] ppp_generic: fix multilink fragment sizes
Date: Wed,  2 Jun 2010 16:04:54 +0100
Message-Id: <1275491094-9526-1-git-send-email-ben@netservers.co.uk>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4C0670E2.1090708@netservers.co.uk>
References: <4C0670E2.1090708@netservers.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug in multilink fragment size calculation introduced by
commit 9c705260feea6ae329bc6b6d5f6d2ef0227eda0a
"ppp: ppp_mp_explode() redesign"

Signed-off-by: Ben McKeegan <ben@netservers.co.uk>
---
 drivers/net/ppp_generic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 0db3894..8b36bfe 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -1416,7 +1416,8 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 		flen = len;
 		if (nfree > 0) {
 			if (pch->speed == 0) {
-				flen = totlen/nfree;
+				if (nfree > 1)
+					flen = DIV_ROUND_UP(len, nfree);
 				if (nbigger > 0) {
 					flen++;
 					nbigger--;
-- 
1.5.6.5

