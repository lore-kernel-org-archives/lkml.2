Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab2ETAE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 20:04:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45626 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2ETAEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 20:04:55 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] net/ipv4/ipconfig: neaten __setup placement
Date: Sun, 20 May 2012 02:04:39 +0200
Message-Id: <1337472279-18615-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __setup macro should follow the corresponding setup handler.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/ipv4/ipconfig.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 92ac7e7..1d8076a 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1626,11 +1626,13 @@ static int __init ip_auto_config_setup(char *addrs)
 
 	return 1;
 }
+__setup("ip=", ip_auto_config_setup);
 
 static int __init nfsaddrs_config_setup(char *addrs)
 {
 	return ip_auto_config_setup(addrs);
 }
+__setup("nfsaddrs=", nfsaddrs_config_setup);
 
 static int __init vendor_class_identifier_setup(char *addrs)
 {
@@ -1641,7 +1643,4 @@ static int __init vendor_class_identifier_setup(char *addrs)
 			vendor_class_identifier);
 	return 1;
 }
-
-__setup("ip=", ip_auto_config_setup);
-__setup("nfsaddrs=", nfsaddrs_config_setup);
 __setup("dhcpclass=", vendor_class_identifier_setup);
-- 
1.7.10

