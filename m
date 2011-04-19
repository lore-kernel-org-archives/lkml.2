Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1DSUnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:43:35 -0400
Received: from kroah.org ([198.145.64.141]:59012 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab1DSUmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:19 2011
Message-Id: <20110419204119.601272869@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:31:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <kees.cook@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [27/28] net: ax25: fix information leak to userland harder
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
 


