Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0D0B2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:28:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47267 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab0D0B2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:28:36 -0400
Date: Tue, 27 Apr 2010 11:28:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20100427112835.f2b6662c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/scsi/iscsi_tcp.c between commit
d7d05548a62c87ee55b0c81933669177f885aa8d ("[SCSI] iscsi_tcp: fix
relogin/shutdown hang") from the  tree and commit
aa395145165cb06a0d0885221bbe0ce4a564391d ("net: sk_sleep() helper") from
the net tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/iscsi_tcp.c
index cdb4fd8,9eae04a..0000000
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@@ -601,9 -599,9 +601,9 @@@ static void iscsi_sw_tcp_conn_stop(stru
  	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
  	write_unlock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
  
- 	if (sock->sk->sk_sleep) {
 -	if (sk_sleep(sock->sk) && waitqueue_active(sk_sleep(sock->sk))) {
++	if (sk_sleep(sock->sk)) {
  		sock->sk->sk_err = EIO;
- 		wake_up_interruptible(sock->sk->sk_sleep);
+ 		wake_up_interruptible(sk_sleep(sock->sk));
  	}
  
  	iscsi_conn_stop(cls_conn, flag);
