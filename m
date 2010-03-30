Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab0C3X0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:26:51 -0400
Received: from kroah.org ([198.145.64.141]:46841 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab0C3XWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:12 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:55 2010
Message-Id: <20100330224854.794391040@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [145/156] tcp: Fix OOB POLLIN avoidance.
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexandra Kossovsky <Alexandra.Kossovsky@oktetlabs.ru>

[ Upstream commit b634f87522dff87712df8bda2a6c9061954d552a ]

From: Alexandra.Kossovsky@oktetlabs.ru

Fixes kernel bugzilla #15541

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -429,7 +429,7 @@ unsigned int tcp_poll(struct file *file,
 		if (tp->urg_seq == tp->copied_seq &&
 		    !sock_flag(sk, SOCK_URGINLINE) &&
 		    tp->urg_data)
-			target--;
+			target++;
 
 		/* Potential race condition. If read of tp below will
 		 * escape above sk->sk_state, we can be illegally awaken


