Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab0IXRAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:00:17 -0400
Received: from kroah.org ([198.145.64.141]:46035 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab0IXQ15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:27:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:15 2010
Message-Id: <20100924162615.593201538@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:23:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [08/80] net: RPS needs to depend upon USE_GENERIC_SMP_HELPERS
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 6dcbc12290abb452a5e42713faa6461b248e2f55 ]

You cannot invoke __smp_call_function_single() unless the
architecture sets this symbol.

Reported-by: Daniel Hellstrom <daniel@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/Kconfig
+++ b/net/Kconfig
@@ -206,7 +206,7 @@ source "net/dcb/Kconfig"
 
 config RPS
 	boolean
-	depends on SMP && SYSFS
+	depends on SMP && SYSFS && USE_GENERIC_SMP_HELPERS
 	default y
 
 menu "Network testing"


