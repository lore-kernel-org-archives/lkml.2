Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab1KSAJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:09:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187Ab1KSAJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:04 2011
Message-Id: <20111119000004.314069503@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [04/26] sh: Fix cached/uncaced address calculation in 29bit mode
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

commit dfd3b596fbbfa48b8e7966ef996d587157554b69 upstream.

In the case of 29bit mode, CAC/UNCAC_ADDR does not return a right address.
This revises this problem by using P1SEGADDR and P2SEGADDR in 29bit mode.

Reported-by: Yutaro Ebihara <ebiharaml@si-linux.co.jp>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Tested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/include/asm/page.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/sh/include/asm/page.h
+++ b/arch/sh/include/asm/page.h
@@ -141,8 +141,13 @@ typedef struct page *pgtable_t;
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_UNCACHED_MAPPING
+#if defined(CONFIG_29BIT)
+#define UNCAC_ADDR(addr)	P2SEGADDR(addr)
+#define CAC_ADDR(addr)		P1SEGADDR(addr)
+#else
 #define UNCAC_ADDR(addr)	((addr) - PAGE_OFFSET + uncached_start)
 #define CAC_ADDR(addr)		((addr) - uncached_start + PAGE_OFFSET)
+#endif
 #else
 #define UNCAC_ADDR(addr)	((addr))
 #define CAC_ADDR(addr)		((addr))


