Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab2HOTu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62888 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab2HOTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Matthew Daley <mattjd@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 062/165] x25: Prevent skb overreads when checking call user data
Date: Wed, 15 Aug 2012 15:46:46 -0400
Message-ID: <1345060109-9187-63-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Daley <mattjd@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7f81e25befdfb3272345a2e775f520e1d515fa20 upstream.

x25_find_listener does not check that the amount of call user data given
in the skb is big enough in per-socket comparisons, hence buffer
overreads may occur.  Fix this by adding a check.

Signed-off-by: Matthew Daley <mattjd@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Acked-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/x25/af_x25.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 36e84e1..3117b9e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -296,7 +296,8 @@ static struct sock *x25_find_listener(struct x25_address *addr,
 			 * Found a listening socket, now check the incoming
 			 * call user data vs this sockets call user data
 			 */
-			if(skb->len > 0 && x25_sk(s)->cudmatchlength > 0) {
+			if (x25_sk(s)->cudmatchlength > 0 &&
+				skb->len >= x25_sk(s)->cudmatchlength) {
 				if((memcmp(x25_sk(s)->calluserdata.cuddata,
 					skb->data,
 					x25_sk(s)->cudmatchlength)) == 0) {
-- 
1.7.12.rc2

