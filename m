Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab0G3Ryp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:54:45 -0400
Received: from kroah.org ([198.145.64.141]:57823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759708Ab0G3RyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:15 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:34 2010
Message-Id: <20100730175134.492926106@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [010/205] r8169: fix mdio_read and update mdio_write according to hw specs
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Timo Teräs <timo.teras@iki.fi>

[ Upstream commit 81a95f049962ec20a9aed888e676208b206f0f2e ]

Realtek confirmed that a 20us delay is needed after mdio_read and
mdio_write operations. Reduce the delay in mdio_write, and add it
to mdio_read too. Also add a comment that the 20us is from hw specs.

Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/r8169.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -558,10 +558,10 @@ static void mdio_write(void __iomem *ioa
 		udelay(25);
 	}
 	/*
-	 * Some configurations require a small delay even after the write
-	 * completed indication or the next write might fail.
+	 * According to hardware specs a 20us delay is required after write
+	 * complete indication, but before sending next command.
 	 */
-	udelay(25);
+	udelay(20);
 }
 
 static int mdio_read(void __iomem *ioaddr, int reg_addr)
@@ -581,6 +581,12 @@ static int mdio_read(void __iomem *ioadd
 		}
 		udelay(25);
 	}
+	/*
+	 * According to hardware specs a 20us delay is required after read
+	 * complete indication, but before sending next command.
+	 */
+	udelay(20);
+
 	return value;
 }
 


