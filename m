Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1B1Qrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:47:32 -0500
Received: from kroah.org ([198.145.64.141]:48045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab1B1Qha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:08 2011
Message-Id: <20110228162408.739075106@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: [30/68] tcp: Increase TCP_MAXSEG socket option minimum.
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

commit 7a1abd08d52fdeddb3e9a5a33f2f15cc6a5674d2 upstream.

As noted by Steve Chen, since commit
f5fff5dc8a7a3f395b0525c02ba92c95d42b7390 ("tcp: advertise MSS
requested by user") we can end up with a situation where
tcp_select_initial_window() does a divide by a zero (or
even negative) mss value.

The problem is that sometimes we effectively subtract
TCPOLEN_TSTAMP_ALIGNED and/or TCPOLEN_MD5SIG_ALIGNED from the mss.

Fix this by increasing the minimum from 8 to 64.

Reported-by: Steve Chen <schen@mvista.com>
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
-		if (val < 8 || val > MAX_TCP_WINDOW) {
+		if (val < 64 || val > MAX_TCP_WINDOW) {
 			err = -EINVAL;
 			break;
 		}


