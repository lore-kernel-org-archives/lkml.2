Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2LPRCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:02:20 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39139 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2LPRCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:02:19 -0500
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Dec 2012 12:02:19 EST
Message-ID: <50CDFB36.1020604@simon.arlott.org.uk>
Date: Sun, 16 Dec 2012 16:47:50 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110823 Thunderbird/5.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Vlad Yasevich <vyasevic@redhat.com>
Subject: [PATCH] ipv6: Fix Makefile offload objects
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit breaks IPv6 TCP transmission for me:
	Commit 75fe83c32248d99e6d5fe64155e519b78bb90481
	Author: Vlad Yasevich <vyasevic@redhat.com>
	Date:   Fri Nov 16 09:41:21 2012 +0000
	ipv6: Preserve ipv6 functionality needed by NET

This patch fixes the typo "ipv6_offload" which should be
"ipv6-offload".

I don't know why not including the offload modules should
break TCP. Disabling all offload options on the NIC didn't
help. Outgoing pulseaudio traffic kept stalling.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 net/ipv6/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 2068ac4..4ea2448 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -41,6 +41,6 @@ obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
 obj-$(CONFIG_IPV6_GRE) += ip6_gre.o
 
 obj-y += addrconf_core.o exthdrs_core.o
-obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6_offload)
+obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6-offload)
 
 obj-$(subst m,y,$(CONFIG_IPV6)) += inet6_hashtables.o
-- 
1.7.8.rc3

-- 
Simon Arlott
