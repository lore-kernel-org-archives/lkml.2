Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0IXQ5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:57:22 -0400
Received: from kroah.org ([198.145.64.141]:46123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597Ab0IXQ2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:12 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.908237696@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [23/80] net/llc: make opt unsigned in llc_ui_setsockopt()
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 339db11b219f36cf7da61b390992d95bb6b7ba2e upstream.

The members of struct llc_sock are unsigned so if we pass a negative
value for "opt" it can cause a sign bug.  Also it can cause an integer
overflow when we multiply "opt * HZ".

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/llc/af_llc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1024,7 +1024,8 @@ static int llc_ui_setsockopt(struct sock
 {
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
-	int rc = -EINVAL, opt;
+	unsigned int opt;
+	int rc = -EINVAL;
 
 	lock_sock(sk);
 	if (unlikely(level != SOL_LLC || optlen != sizeof(int)))


