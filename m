Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab0G3SMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:12:32 -0400
Received: from kroah.org ([198.145.64.141]:59094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712Ab0G3R5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:48 2010
Message-Id: <20100730175148.582072562@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [161/205] isdn/gigaset: correct CAPI voice connection encoding
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 278a582989ade4cb5335762d6c5999562018859d upstream.

Make the Gigaset CAPI driver select L2_VOICE (AT^SBPR=2) as the
layer 2 encoding for transparent connections, like the ISDN4Linux
variant.  L2_BITSYNC (AT^SBPR=0) mutes internal connections and
distorts external ones.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/capi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -1338,13 +1338,13 @@ static void do_connect_req(struct gigase
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
@@ -1467,13 +1467,13 @@ static void do_connect_resp(struct gigas
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


