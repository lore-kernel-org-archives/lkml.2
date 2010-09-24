Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab0IXQe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:34:59 -0400
Received: from kroah.org ([198.145.64.141]:37005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab0IXQet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:34:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:44 2010
Message-Id: <20100924163344.189112368@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [02/68] sparc: Provide io{read,write}{16,32}be().
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 1bff4dbb79a2bc0ee4881c8ea6a4fbed64ea6309 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/io_32.h |    4 ++++
 arch/sparc/include/asm/io_64.h |    4 ++++
 2 files changed, 8 insertions(+)

--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -249,10 +249,14 @@ extern void iounmap(volatile void __iome
 
 #define ioread8(X)			readb(X)
 #define ioread16(X)			readw(X)
+#define ioread16be(X)			__raw_readw(X)
 #define ioread32(X)			readl(X)
+#define ioread32be(X)			__raw_readl(X)
 #define iowrite8(val,X)			writeb(val,X)
 #define iowrite16(val,X)		writew(val,X)
+#define iowrite16be(val,X)		__raw_writew(val,X)
 #define iowrite32(val,X)		writel(val,X)
+#define iowrite32be(val,X)		__raw_writel(val,X)
 
 static inline void ioread8_rep(void __iomem *port, void *buf, unsigned long count)
 {
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -468,10 +468,14 @@ static inline void iounmap(volatile void
 
 #define ioread8(X)			readb(X)
 #define ioread16(X)			readw(X)
+#define ioread16be(X)			__raw_readw(X)
 #define ioread32(X)			readl(X)
+#define ioread32be(X)			__raw_readl(X)
 #define iowrite8(val,X)			writeb(val,X)
 #define iowrite16(val,X)		writew(val,X)
+#define iowrite16be(val,X)		__raw_writew(val,X)
 #define iowrite32(val,X)		writel(val,X)
+#define iowrite32be(val,X)		__raw_writel(val,X)
 
 /* Create a virtual mapping cookie for an IO port range */
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);


