Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1KJFHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:07:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934196Ab1KJD13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:14 2011
Message-Id: <20111109212714.798975061@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gao feng <gaofeng@cn.fujitsu.com>,
        Flavio Leitner <fbl@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [141/262] netconsole: enable netconsole can make net_device refcnt incorrent
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit d5123480b1d6f7d1a5fe1a13520cef88fb5d4c84 ]

There is no check if netconsole is enabled current.
so when exec echo 1 > enabled;
the reference of net_device will increment always.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Acked-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/netconsole.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -307,6 +307,11 @@ static ssize_t store_enabled(struct netc
 		return err;
 	if (enabled < 0 || enabled > 1)
 		return -EINVAL;
+	if (enabled == nt->enabled) {
+		printk(KERN_INFO "netconsole: network logging has already %s\n",
+				nt->enabled ? "started" : "stopped");
+		return -EINVAL;
+	}
 
 	if (enabled) {	/* 1 */
 


