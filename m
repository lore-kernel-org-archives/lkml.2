Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2GWCBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:01:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194Ab2GWBms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:48 -0400
Message-Id: <20120723010707.073305741@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 102/108] bonding: debugfs and network namespaces are incompatible
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 96ca7ffe748bf91f851e6aa4479aa11c8b1122ba upstream.

The bonding debugfs support has been broken in the presence of network
namespaces since it has been added.  The debugfs support does not handle
multiple bonding devices with the same name in different network
namespaces.

I haven't had any bug reports, and I'm not interested in getting any.
Disable the debugfs support when network namespaces are enabled.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index 3680aa2..2cf084e 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -6,7 +6,7 @@
 #include "bonding.h"
 #include "bond_alb.h"
 
-#ifdef CONFIG_DEBUG_FS
+#if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_NET_NS)
 
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>


