Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab0LHAsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:14 -0500
Received: from kroah.org ([198.145.64.141]:58656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab0LHAsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:09 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:35 2010
Message-Id: <20101208004435.117449897@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [108/127] memory corruption in X.25 facilities parsing
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: andrew hendry <andrew.hendry@gmail.com>

commit a6331d6f9a4298173b413cf99a40cc86a9d92c37 upstream.

Signed-of-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/x25/x25_facilities.c |    8 ++++----
 net/x25/x25_in.c         |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/net/x25/x25_facilities.c
+++ b/net/x25/x25_facilities.c
@@ -134,15 +134,15 @@ int x25_parse_facilities(struct sk_buff
 		case X25_FAC_CLASS_D:
 			switch (*p) {
 			case X25_FAC_CALLING_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->calling_len = p[2];
 				memcpy(dte_facs->calling_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLING_AE;
 				break;
 			case X25_FAC_CALLED_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->called_len = p[2];
 				memcpy(dte_facs->called_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLED_AE;
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -118,6 +118,8 @@ static int x25_state1_machine(struct soc
 						&x25->vc_facil_mask);
 			if (len > 0)
 				skb_pull(skb, len);
+			else
+				return -1;
 			/*
 			 *	Copy any Call User Data.
 			 */


