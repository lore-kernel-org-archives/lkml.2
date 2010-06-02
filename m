Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab0FBPSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:18:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:58562 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab0FBPSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:18:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,347,1272870000"; 
   d="scan'208";a="804106882"
From: "Paoloni, Gabriele" <gabriele.paoloni@intel.com>
To: Ben McKeegan <ben@netservers.co.uk>,
       "davem@davemloft.net" <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
       "paulus@samba.org" <paulus@samba.org>
Date: Wed, 2 Jun 2010 16:17:59 +0100
Subject: RE: [PATCH] ppp_generic: fix multilink fragment sizes
Thread-Topic: [PATCH] ppp_generic: fix multilink fragment sizes
Thread-Index: AcsCZP+qY2zPdToHRRC+8AwT79+FUwAANpcw
Message-ID: <DF7BB929B28FCF479E888E3D9F8D9E88D3E16B5A@irsmsx502.ger.corp.intel.com>
References: <4C0670E2.1090708@netservers.co.uk>
 <1275491094-9526-1-git-send-email-ben@netservers.co.uk>
In-Reply-To: <1275491094-9526-1-git-send-email-ben@netservers.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proposed patch looks wrong to me.

nbigger is already doing the job; I didn't use DIV_ROUND_UP because in general we don't have always to roundup, otherwise we would exceed the total bandwidth.

Regards

Gabriele Paoloni

-----Original Message-----
From: Ben McKeegan [mailto:ben@netservers.co.uk] 
Sent: 02 June 2010 16:05
To: davem@davemloft.net
Cc: ben@netservers.co.uk; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Paoloni, Gabriele; alan@lxorguk.ukuu.org.uk; linux-ppp@vger.kernel.org; paulus@samba.org
Subject: [PATCH] ppp_generic: fix multilink fragment sizes

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

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


