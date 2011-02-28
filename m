Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab1B1QrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:47:10 -0500
Received: from kroah.org ([198.145.64.141]:48054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab1B1Qhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:08 2011
Message-Id: <20110228162408.842718328@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: [31/68] tcp: Make TCP_MAXSEG minimum more correct.
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

commit c39508d6f118308355468314ff414644115a07f3 upstream.

Use TCP_MIN_MSS instead of constant 64.

Reported-by: Min Zhang <mzhang@mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2117,7 +2117,7 @@ static int do_tcp_setsockopt(struct sock
 		/* Values greater than interface MTU won't take effect. However
 		 * at the point when this call is done we typically don't yet
 		 * know which interface is going to be used */
-		if (val < 64 || val > MAX_TCP_WINDOW) {
+		if (val < TCP_MIN_MSS || val > MAX_TCP_WINDOW) {
 			err = -EINVAL;
 			break;
 		}


