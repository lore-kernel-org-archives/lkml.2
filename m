Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab2JJWy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:54:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54011 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757625Ab2JJWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:14 -0400
X-Sasl-enc: 2VxA5DSXBSX2j9it9UjewxqstT31L7kaBBawV/LZBTJm 1349909653
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 031/133] xfrm_user: fix info leak in copy_to_user_auth()
Date: Thu, 11 Oct 2012 07:50:57 +0900
Message-Id: <20121010224900.073068936@linuxfoundation.org>
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

[ Upstream commit 4c87308bdea31a7b4828a51f6156e6f721a1fcc9 ]

copy_to_user_auth() fails to initialize the remainder of alg_name and
therefore discloses up to 54 bytes of heap memory via netlink to
userland.

Use strncpy() instead of strcpy() to fill the trailing bytes of alg_name
with null bytes.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -742,7 +742,7 @@ static int copy_to_user_auth(struct xfrm
 		return -EMSGSIZE;
 
 	algo = nla_data(nla);
-	strcpy(algo->alg_name, auth->alg_name);
+	strncpy(algo->alg_name, auth->alg_name, sizeof(algo->alg_name));
 	memcpy(algo->alg_key, auth->alg_key, (auth->alg_key_len + 7) / 8);
 	algo->alg_key_len = auth->alg_key_len;
 


