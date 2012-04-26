Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab2DZSaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:30:23 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:35219 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab2DZSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:30:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1335465012!2965336!28
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] IPVS: ip_vs_sync.c: local functions should not be exposed globally
Date: Thu, 26 Apr 2012 11:29:53 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204261129.53927.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions not referenced outside of a source file should be marked
static to prevent it from being exposed globally.

This quiets the sparse warnings:

warning: symbol 'ip_vs_sync_conn_v0' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "David S. Miller" <davem@davemloft.net>

---

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index bf5e538..49a1fe8 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -446,7 +446,7 @@ ip_vs_sync_buff_create_v0(struct netns_ipvs *ipvs)
  *      Version 0 , could be switched in by sys_ctl.
  *      Add an ip_vs_conn information into the current sync_buff.
  */
-void ip_vs_sync_conn_v0(struct net *net, struct ip_vs_conn *cp)
+static void ip_vs_sync_conn_v0(struct net *net, struct ip_vs_conn *cp)
 {
 	struct netns_ipvs *ipvs = net_ipvs(net);
 	struct ip_vs_sync_mesg_v0 *m;
