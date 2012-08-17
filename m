Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030700Ab2HQD1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:27:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46741 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030629Ab2HQD0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:55 -0400
Message-Id: <20120817030244.740450406@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        <rucsoftsec@gmail.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 06/37] caif: fix NULL pointer check
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

[ Upstream commit c66b9b7d365444b433307ebb18734757cb668a02 ]

Reported-by: <rucsoftsec@gmail.com>
Resolves-bug: http://bugzilla.kernel.org/show_bug?44441
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/caif/caif_serial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 23406e6..ae286a9 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -325,6 +325,9 @@ static int ldisc_open(struct tty_struct *tty)
 
 	sprintf(name, "cf%s", tty->name);
 	dev = alloc_netdev(sizeof(*ser), name, caifdev_setup);
+	if (!dev)
+		return -ENOMEM;
+
 	ser = netdev_priv(dev);
 	ser->tty = tty_kref_get(tty);
 	ser->dev = dev;


