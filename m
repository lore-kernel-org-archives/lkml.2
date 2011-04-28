Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab1D1BeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:34:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55872 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab1D1BeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:34:09 -0400
Date: Thu, 28 Apr 2011 11:34:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: linux-next: manual merge of the bluetooth tree with Linus' tree
Message-Id: <20110428113404.081a74a5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

Today's linux-next merge of the bluetooth tree got a conflict in
net/bluetooth/l2cap_sock.c between commit 25985edcedea ("Fix common
misspellings") from Linus' tree and commit dbe1c0aea650 ("Bluetooth: Move
conn to struct l2cap_chan") from the bluetooth tree.

Just context changes.  I fxied it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/bluetooth/l2cap_sock.c
index 47394a1,09cc7a0..0000000
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@@ -678,8 -692,8 +692,8 @@@ static int l2cap_sock_setsockopt(struc
  		}
  
  		if (opt == BT_FLUSHABLE_OFF) {
- 			struct l2cap_conn *conn = l2cap_pi(sk)->conn;
+ 			struct l2cap_conn *conn = chan->conn;
 -			/* proceed futher only when we have l2cap_conn and
 +			/* proceed further only when we have l2cap_conn and
  			   No Flush support in the LM */
  			if (!conn || !lmp_no_flush_capable(conn->hcon->hdev)) {
  				err = -EINVAL;
