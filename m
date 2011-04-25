Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1DYUZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:36 -0400
Received: from 1wt.eu ([62.212.114.60]:34570 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab1DYUZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:22 -0400
Message-Id: <20110425200240.425545895@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Kees Cook <kees.cook@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 171/173] net: ax25: fix information leak to userland harder
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kees Cook <kees.cook@canonical.com>

commit 5b919f833d9d60588d026ad82d17f17e8872c7a9 upstream.

Commit fe10ae53384e48c51996941b7720ee16995cbcb7 adds a memset() to clear
the structure being sent back to userspace, but accidentally used the
wrong size.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ax25/af_ax25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1391,7 +1391,7 @@ static int ax25_getname(struct socket *s
 	ax25_cb *ax25;
 	int err = 0;
 
-	memset(fsa, 0, sizeof(fsa));
+	memset(fsa, 0, sizeof(*fsa));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 


