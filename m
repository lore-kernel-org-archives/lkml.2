Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162473Ab1FAIU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:20:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161810Ab1FAIUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:20:50 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:28 2011
Message-Id: <20110601081128.204198782@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:35 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [065/165] net: fix __dst_destroy_metrics_generic()
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 760
Lines: 26


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit b30c516f875004f025f4d10147bde28c5e98466b ]

dst_default_metrics is readonly, we dont want to kfree() it later.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dst.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -314,7 +314,7 @@ void __dst_destroy_metrics_generic(struc
 {
 	unsigned long prev, new;
 
-	new = (unsigned long) dst_default_metrics;
+	new = ((unsigned long) dst_default_metrics) | DST_METRICS_READ_ONLY;
 	prev = cmpxchg(&dst->_metrics, old, new);
 	if (prev == old)
 		kfree(__DST_METRICS_PTR(old));


