Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0F0KC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 06:02:29 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:55210 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531Ab0F0KC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 06:02:27 -0400
Date: Sun, 27 Jun 2010 12:00:25 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] net/Makefile: conditionally descend to wireless and
 ieee802154
Message-ID: <20100627120025.0232a9d0@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't descend to wireless and ieee802154 unless they are actually used.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 net/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/Makefile b/net/Makefile
index cb7bdc1..41d4200 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -50,7 +50,7 @@ endif
 obj-$(CONFIG_IP_DCCP)		+= dccp/
 obj-$(CONFIG_IP_SCTP)		+= sctp/
 obj-$(CONFIG_RDS)		+= rds/
-obj-y				+= wireless/
+obj-$(CONFIG_WIRELESS)		+= wireless/
 obj-$(CONFIG_MAC80211)		+= mac80211/
 obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
@@ -61,7 +61,7 @@ obj-$(CONFIG_CAIF)		+= caif/
 ifneq ($(CONFIG_DCB),)
 obj-y				+= dcb/
 endif
-obj-y				+= ieee802154/
+obj-$(CONFIG_IEEE802154)	+= ieee802154/
 
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
-- 
1.7.1
