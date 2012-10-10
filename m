Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2JJWya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:54:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55892 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757418Ab2JJWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:17 -0400
X-Sasl-enc: flwZPxEU/QRO+5iolRiaJrhwKP+XBLlcty82X60Y5DSh 1349909656
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 032/133] xfrm_user: fix info leak in copy_to_user_state()
Date: Thu, 11 Oct 2012 07:50:58 +0900
Message-Id: <20121010224900.255567160@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit f778a636713a435d3a922c60b1622a91136560c1 ]

The memory reserved to dump the xfrm state includes the padding bytes of
struct xfrm_usersa_info added by the compiler for alignment (7 for
amd64, 3 for i386). Add an explicit memset(0) before filling the buffer
to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -689,6 +689,7 @@ out:
 
 static void copy_to_user_state(struct xfrm_state *x, struct xfrm_usersa_info *p)
 {
+	memset(p, 0, sizeof(*p));
 	memcpy(&p->id, &x->id, sizeof(p->id));
 	memcpy(&p->sel, &x->sel, sizeof(p->sel));
 	memcpy(&p->lft, &x->lft, sizeof(p->lft));


