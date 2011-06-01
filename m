Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161598Ab1FAJVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:21:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161485Ab1FAILJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:11:09 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:16 2011
Message-Id: <20110601080315.717294324@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:51 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [055/146] net: Do not wrap sysctl igmp_max_memberships in IP_MULTICAST
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

[ Upstream commit 192910a6cca5e50e5bd6cbd1da0e7376c7adfe62 ]

controlling igmp_max_membership is useful even when IP_MULTICAST
is off.
Quagga(an OSPF deamon) uses multicast addresses for all interfaces
using a single socket and hits igmp_max_membership limit when
there are 20 interfaces or more.
Always export sysctl igmp_max_memberships in proc, just like
igmp_max_msf

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/sysctl_net_ipv4.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -311,7 +311,6 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_do_large_bitmap,
 	},
-#ifdef CONFIG_IP_MULTICAST
 	{
 		.procname	= "igmp_max_memberships",
 		.data		= &sysctl_igmp_max_memberships,
@@ -319,8 +318,6 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
-
-#endif
 	{
 		.procname	= "igmp_max_msf",
 		.data		= &sysctl_igmp_max_msf,


