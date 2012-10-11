Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab2JKBTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:19:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43629 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933843Ab2JKBTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:19:03 -0400
X-Sasl-enc: Td8Vww4ZNWQUsU+IQFeca5mqfLagWTcSJGHTuMECj1vn 1349918342
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 029/120] xfrm_user: fix info leak in copy_to_user_policy()
Date: Thu, 11 Oct 2012 09:59:41 +0900
Message-Id: <20121011005830.884258457@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 7b789836f434c87168eab067cfbed1ec4783dffd ]

The memory reserved to dump the xfrm policy includes multiple padding
bytes added by the compiler for alignment (padding bytes in struct
xfrm_selector and struct xfrm_userpolicy_info). Add an explicit
memset(0) before filling the buffer to avoid the heap info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1300,6 +1300,7 @@ static void copy_from_user_policy(struct
 
 static void copy_to_user_policy(struct xfrm_policy *xp, struct xfrm_userpolicy_info *p, int dir)
 {
+	memset(p, 0, sizeof(*p));
 	memcpy(&p->sel, &xp->selector, sizeof(p->sel));
 	memcpy(&p->lft, &xp->lft, sizeof(p->lft));
 	memcpy(&p->curlft, &xp->curlft, sizeof(p->curlft));


