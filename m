Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab3AIOln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:41:43 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:53426 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab3AIOll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:41:41 -0500
From: Romain KUNTZ <r.kuntz@ipflavors.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 1/1] ipv6: fix the noflags test in addrconf_get_prefix_route
Date: Wed, 9 Jan 2013 15:36:40 +0100
Message-Id: <470C14E4-2866-4C55-89A3-D6751E1587C4@ipflavors.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andreas Hofmeister <andi@collax.com>,
        Romain KUNTZ <r.kuntz@ipflavors.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e7ece201c35615c44a3cfdc10ee28ad5a5878f41 Mon Sep 17 00:00:00 2001
From: Romain Kuntz <r.kuntz@ipflavors.com>
Date: Wed, 9 Jan 2013 15:02:26 +0100
Subject: [PATCH 1/1] ipv6: fix the noflags test in addrconf_get_prefix_route

The tests on the flags in addrconf_get_prefix_route() does no make
much sense: the 'noflags' parameter contains the set of flags that
must not match with the route flags, so the test must be done
against 'noflags', and not against 'flags'.

Signed-off-by: Romain Kuntz <r.kuntz@ipflavors.com>
---
 net/ipv6/addrconf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 408cac4a..29ba4ff 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1877,7 +1877,7 @@ static struct rt6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
 			continue;
 		if ((rt->rt6i_flags & flags) != flags)
 			continue;
-		if ((noflags != 0) && ((rt->rt6i_flags & flags) != 0))
+		if ((rt->rt6i_flags & noflags) != 0)
 			continue;
 		dst_hold(&rt->dst);
 		break;
-- 
1.7.2.5

