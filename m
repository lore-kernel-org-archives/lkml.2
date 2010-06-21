Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab0FVAEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 20:04:35 -0400
Received: from gimli.pxnet.com ([89.1.7.7]:38337 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab0FVAEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 20:04:33 -0400
Subject: [PATCH 2/5] isdn/gigaset: correct CAPI voice connection encoding
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20100622-patch-gigaset-02.tilman@imap.cc>
In-Reply-To: <20100622-patch-gigaset-00.tilman@imap.cc>
References: <20100622-patch-gigaset-00.tilman@imap.cc>
Date: Tue, 22 Jun 2010 01:54:35 +0200 (CEST)
X-Spam-Score: -2.054 () AWL,BAYES_00,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the Gigaset CAPI driver select L2_VOICE (AT^SBPR=2) as the
layer 2 encoding for transparent connections, like the ISDN4Linux
variant.  L2_BITSYNC (AT^SBPR=0) mutes internal connections and
distorts external ones.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/capi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 245a608..cb55ead 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -1327,13 +1327,13 @@ static void do_connect_req(struct gigaset_capi_ctr *iif,
 			bcs->proto2 = L2_HDLC;
 			break;
 		case 1:
-			bcs->proto2 = L2_BITSYNC;
+			bcs->proto2 = L2_VOICE;
 			break;
 		default:
 			dev_warn(cs->dev,
 			    "B1 Protocol %u unsupported, using Transparent\n",
 				 cmsg->B1protocol);
-			bcs->proto2 = L2_BITSYNC;
+			bcs->proto2 = L2_VOICE;
 		}
 		if (cmsg->B2protocol != 1)
 			dev_warn(cs->dev,
@@ -1456,13 +1456,13 @@ static void do_connect_resp(struct gigaset_capi_ctr *iif,
 				bcs->proto2 = L2_HDLC;
 				break;
 			case 1:
-				bcs->proto2 = L2_BITSYNC;
+				bcs->proto2 = L2_VOICE;
 				break;
 			default:
 				dev_warn(cs->dev,
 			"B1 Protocol %u unsupported, using Transparent\n",
 					 cmsg->B1protocol);
-				bcs->proto2 = L2_BITSYNC;
+				bcs->proto2 = L2_VOICE;
 			}
 			if (cmsg->B2protocol != 1)
 				dev_warn(cs->dev,
-- 
1.6.5.3.298.g39add

