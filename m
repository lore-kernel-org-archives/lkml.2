Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab1KCCPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:15:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869Ab1KCBec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:54 2011
Message-Id: <20111102221454.612949436@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Daley <mattjd@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [049/107] x25: Prevent skb overreads when checking call user data
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Daley <mattjd@gmail.com>

commit 7f81e25befdfb3272345a2e775f520e1d515fa20 upstream.

x25_find_listener does not check that the amount of call user data given
in the skb is big enough in per-socket comparisons, hence buffer
overreads may occur.  Fix this by adding a check.

Signed-off-by: Matthew Daley <mattjd@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Acked-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/x25/af_x25.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -294,7 +294,8 @@ static struct sock *x25_find_listener(st
 			 * Found a listening socket, now check the incoming
 			 * call user data vs this sockets call user data
 			 */
-			if(skb->len > 0 && x25_sk(s)->cudmatchlength > 0) {
+			if (x25_sk(s)->cudmatchlength > 0 &&
+				skb->len >= x25_sk(s)->cudmatchlength) {
 				if((memcmp(x25_sk(s)->calluserdata.cuddata,
 					skb->data,
 					x25_sk(s)->cudmatchlength)) == 0) {


