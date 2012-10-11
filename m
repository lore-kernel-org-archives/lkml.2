Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab2JKBdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:33:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45340 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933945Ab2JKBUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:20:08 -0400
X-Sasl-enc: 9T6lWBpiFdmTcAC3k1zyHwpEIiBcBotjHroUDSFVbttL 1349918406
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 042/120] ipv6: fix return value check in fib6_add()
Date: Thu, 11 Oct 2012 09:59:54 +0900
Message-Id: <20121011005833.228132919@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit f950c0ecc78f745e490d615280e031de4dbb1306 ]

In case of error, the function fib6_add_1() returns ERR_PTR()
or NULL pointer. The ERR_PTR() case check is missing in fib6_add().

dpatch engine is used to generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -818,6 +818,10 @@ int fib6_add(struct fib6_node *root, str
 					offsetof(struct rt6_info, rt6i_src),
 					allow_create, replace_required);
 
+			if (IS_ERR(sn)) {
+				err = PTR_ERR(sn);
+				sn = NULL;
+			}
 			if (!sn) {
 				/* If it is failed, discard just allocated
 				   root, and then (in st_failure) stale node


