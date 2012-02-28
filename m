Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058Ab2B1BLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:11:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54256 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964926Ab2B1BLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.166 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010431.523414483@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/72] veth: Enforce minimum size of VETH_INFO_PEER
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hagen Paul Pfeifer <hagen@jauu.net>

[ Upstream commit 237114384ab22c174ec4641e809f8e6cbcfce774 ]

VETH_INFO_PEER carries struct ifinfomsg plus optional IFLA
attributes. A minimal size of sizeof(struct ifinfomsg) must be
enforced or we may risk accessing that struct beyond the limits
of the netlink message.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/veth.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -423,7 +423,9 @@ static void veth_dellink(struct net_devi
 	unregister_netdevice_queue(peer, head);
 }
 
-static const struct nla_policy veth_policy[VETH_INFO_MAX + 1];
+static const struct nla_policy veth_policy[VETH_INFO_MAX + 1] = {
+	[VETH_INFO_PEER]	= { .len = sizeof(struct ifinfomsg) },
+};
 
 static struct rtnl_link_ops veth_link_ops = {
 	.kind		= DRV_NAME,


