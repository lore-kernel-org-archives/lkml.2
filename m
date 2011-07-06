Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1GFCxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 22:53:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39788 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab1GFCxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 22:53:35 -0400
Date: Wed, 6 Jul 2011 12:53:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20110706125329.6e5bdd1a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/bluetooth/l2cap_core.c between commit 9fa7e4f76f36 ("Bluetooth: Fix
regression with incoming L2CAP connections") from the wireless-current
tree and commit 89bc500e41fc ("Bluetooth: Add state tracking to struct
l2cap_chan") from the net tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/bluetooth/l2cap_core.c
index ebff14c,9ec9c8c..0000000
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@@ -2323,8 -2530,7 +2530,8 @@@ static inline int l2cap_config_req(stru
  
  	sk = chan->sk;
  
- 	if ((bt_sk(sk)->defer_setup && sk->sk_state != BT_CONNECT2) ||
- 		 (!bt_sk(sk)->defer_setup && sk->sk_state != BT_CONFIG)) {
 -	if (chan->state != BT_CONFIG) {
++	if ((bt_sk(sk)->defer_setup && chan->state != BT_CONNECT2) ||
++		 (!bt_sk(sk)->defer_setup && chan->state != BT_CONFIG)) {
  		struct l2cap_cmd_rej rej;
  
  		rej.reason = cpu_to_le16(0x0002);
