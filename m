Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2D3Rxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:53:52 -0400
Received: from kanga.kvack.org ([205.233.56.17]:41722 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab2D3Rxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:53:51 -0400
X-Greylist: delayed 1786 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2012 13:53:51 EDT
Date: Mon, 30 Apr 2012 13:24:02 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net/l2tp: fix build error in l2tp from missing ipv6 checksum include
Message-ID: <20120430172402.GL17021@kvack.org>
References: <20120430155836.44bcf3846c80cf686bb9cb77@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430155836.44bcf3846c80cf686bb9cb77@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Can you please verify if the patch below fixes the issue?  Thanks.

		-ben
----
net/l2tp: fix build error in l2tp from missing ipv6 checksum include

L2TP needs to ensure the IPv6 checksum helpers are included.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index e91d559..0ca9bc3 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -56,6 +56,7 @@
 #include <net/inet6_connection_sock.h>
 #include <net/inet_ecn.h>
 #include <net/ip6_route.h>
+#include <net/ip6_checksum.h>
 
 #include <asm/byteorder.h>
 #include <linux/atomic.h>
