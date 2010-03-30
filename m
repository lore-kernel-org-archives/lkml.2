Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0C3X3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:29:43 -0400
Received: from kroah.org ([198.145.64.141]:46699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab0C3XVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:45 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:45 2010
Message-Id: <20100330224844.492238213@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhu Yi <yi.zhu@intel.com>, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [129/156] net: add __must_check to sk_add_backlog
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

[ Upstream commit 4045635318538d3ddd2007720412fdc4b08f6a62 ]

Add the "__must_check" tag to sk_add_backlog() so that any failure to
check and drop packets will be warned about.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/sock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -589,7 +589,7 @@ static inline void __sk_add_backlog(stru
 }
 
 /* The per-socket spinlock must be held here. */
-static inline int sk_add_backlog(struct sock *sk, struct sk_buff *skb)
+static inline __must_check int sk_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
 	if (sk->sk_backlog.len >= max(sk->sk_backlog.limit, sk->sk_rcvbuf << 1))
 		return -ENOBUFS;


