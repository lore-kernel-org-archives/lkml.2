Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab2GLXoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:44:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537Ab2GLWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:37:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>
Subject: [ 029/187] ipv6: fib: Restore NTF_ROUTER exception in fib6_age()
Date: Thu, 12 Jul 2012 15:33:05 -0700
Message-Id: <20120712191524.980089380@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Graf <tgraf@suug.ch>

[ Upstream commit 8bd74516b1bd9308c17f67583134d93f777203ca ]

Commit 5339ab8b1dd82 (ipv6: fib: Convert fib6_age() to
dst_neigh_lookup().) seems to have mistakenly inverted the
exception for cached NTF_ROUTER routes.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1560,7 +1560,7 @@ static int fib6_age(struct rt6_info *rt,
 				neigh_flags = neigh->flags;
 				neigh_release(neigh);
 			}
-			if (neigh_flags & NTF_ROUTER) {
+			if (!(neigh_flags & NTF_ROUTER)) {
 				RT6_TRACE("purging route %p via non-router but gateway\n",
 					  rt);
 				return -1;


