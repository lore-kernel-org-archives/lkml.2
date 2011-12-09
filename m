Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1LIVWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 16:22:21 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:53996 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751278Ab1LIVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 16:22:19 -0500
Message-ID: <4EE289FE.90006@xenotime.net>
Date: Fri, 09 Dec 2011 14:21:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sjur Brendeland <sjur.brandeland@stericsson.com>
Subject: [PATCH -next] xshm: fix build errors, depends on NET
References: <20111209163247.1de15dcb5b735ca5e1ad030b@canb.auug.org.au>
In-Reply-To: <20111209163247.1de15dcb5b735ca5e1ad030b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors in xshm.  xshm uses netlink, so it
should depend on NET.

ERROR: "genl_unregister_family" [drivers/xshm/xshm.ko] undefined!
ERROR: "netlink_unicast" [drivers/xshm/xshm.ko] undefined!
ERROR: "genl_register_family_with_ops" [drivers/xshm/xshm.ko] undefined!
ERROR: "init_net" [drivers/xshm/xshm.ko] undefined!
ERROR: "__alloc_skb" [drivers/xshm/xshm.ko] undefined!
ERROR: "kfree_skb" [drivers/xshm/xshm.ko] undefined!
ERROR: "skb_put" [drivers/xshm/xshm.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Sjur Brendeland <sjur.brandeland@stericsson.com>
---
 drivers/xshm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20111209.orig/drivers/xshm/Kconfig
+++ linux-next-20111209/drivers/xshm/Kconfig
@@ -5,6 +5,7 @@ config XSHM
 
 config XSHM_CHR
 	tristate "Character device for External Shared Memory (XSHM)"
+	depends on NET
 	select XSHM
 	default n
 	---help---
