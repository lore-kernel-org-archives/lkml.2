Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab0FCJOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:14:54 -0400
Received: from mail.netservers.co.uk ([80.248.178.71]:51609 "EHLO
	mail.netservers.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158Ab0FCJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:14:52 -0400
X-Envelope-From: ben@netservers.co.uk
From: Ben McKeegan <ben@netservers.co.uk>
To: davem@davemloft.net
Cc: ben@netservers.co.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       gabriele.paoloni@intel.com, alan@lxorguk.ukuu.org.uk,
       linux-ppp@vger.kernel.org, paulus@samba.org
Subject: [PATCH] ppp_generic: fix multilink fragment sizes
Date: Thu,  3 Jun 2010 10:14:33 +0100
Message-Id: <1275556473-14613-1-git-send-email-ben@netservers.co.uk>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <DF7BB929B28FCF479E888E3D9F8D9E88D3E1706A@irsmsx502.ger.corp.intel.com>
References: <DF7BB929B28FCF479E888E3D9F8D9E88D3E1706A@irsmsx502.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug in multilink fragment size calculation introduced by
commit 9c705260feea6ae329bc6b6d5f6d2ef0227eda0a
"ppp: ppp_mp_explode() redesign"

Signed-off-by: Ben McKeegan <ben@netservers.co.uk>
---
 drivers/net/ppp_generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 0db3894..c980f74 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -1416,7 +1416,7 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 		flen = len;
 		if (nfree > 0) {
 			if (pch->speed == 0) {
-				flen = totlen/nfree;
+				flen = len/nfree;
 				if (nbigger > 0) {
 					flen++;
 					nbigger--;
-- 
1.5.6.5

