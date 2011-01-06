Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1AFA3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:51 -0500
Received: from kroah.org ([198.145.64.141]:35689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab1AFA3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:46 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:01 2011
Message-Id: <20110106002301.863852673@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [055/152] tcp: Make TCP_MAXSEG minimum more correct.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit c39508d6f118308355468314ff414644115a07f3 ]

Use TCP_MIN_MSS instead of constant 64.

Reported-by: Min Zhang <mzhang@mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2246,7 +2246,7 @@ static int do_tcp_setsockopt(struct sock
 		/* Values greater than interface MTU won't take effect. However
 		 * at the point when this call is done we typically don't yet
 		 * know which interface is going to be used */
-		if (val < 64 || val > MAX_TCP_WINDOW) {
+		if (val < TCP_MIN_MSS || val > MAX_TCP_WINDOW) {
 			err = -EINVAL;
 			break;
 		}


