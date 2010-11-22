Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0KVBE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:04:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab0KVBEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jfH9X8DpmBIcwYvLCq9Ib3+q9yN2xzuHWoABCmWEIhJsfI5ZWDMKaCauZpl7GTgVZ4
         G94Wgi4IU313IbML2YcBOmG7FLhwIoD25SAVUQ4BOaXhvsR8Z0KS/Md7r1UIFHpbEw6J
         0xdb5uwJmJX5ZVyVmROZCwu8i8jg4sCOcSgqQ=
From: Tracey Dent <tdent48227@gmail.com>
To: davem@davemloft.net
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        sjur.brandeland@stericsson.com, socketcan@hartkopp.net,
        urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
        sage@newdream.net, ceph-devel@vger.kernel.org, wang840925@gmail.com,
        jlayton@redhat.com, kaber@trash.net, pekkas@netcore.fi,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, samuel@sortiz.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 07/17] Net: ipv4: netfilter: Makefile: Remove deprecated kbuild goal  definitions
Date: Sun, 21 Nov 2010 20:03:18 -0500
Message-Id: <1290387808-2239-8-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276
In-Reply-To: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
References: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs
because -objs is deprecated and not mentioned in
Documentation/kbuild/makefiles.txt.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 net/ipv4/netfilter/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 4811159..19eb59d 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -3,15 +3,15 @@
 #
 
 # objects for l3 independent conntrack
-nf_conntrack_ipv4-objs  :=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
+nf_conntrack_ipv4-y	:=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
 ifeq ($(CONFIG_NF_CONNTRACK_PROC_COMPAT),y)
 ifeq ($(CONFIG_PROC_FS),y)
 nf_conntrack_ipv4-objs	+= nf_conntrack_l3proto_ipv4_compat.o
 endif
 endif
 
-nf_nat-objs		:= nf_nat_core.o nf_nat_helper.o nf_nat_proto_unknown.o nf_nat_proto_common.o nf_nat_proto_tcp.o nf_nat_proto_udp.o nf_nat_proto_icmp.o
-iptable_nat-objs	:= nf_nat_rule.o nf_nat_standalone.o
+nf_nat-y		:= nf_nat_core.o nf_nat_helper.o nf_nat_proto_unknown.o nf_nat_proto_common.o nf_nat_proto_tcp.o nf_nat_proto_udp.o nf_nat_proto_icmp.o
+iptable_nat-y	:= nf_nat_rule.o nf_nat_standalone.o
 
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
-- 
1.7.3.2.245.g03276

