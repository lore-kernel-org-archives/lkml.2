Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2BWXTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:19:21 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57502 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2BWXTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:19:19 -0500
Date: Thu, 23 Feb 2012 18:19:04 -0500 (EST)
Message-Id: <20120223.181904.501214130038312055.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org, w.landgraf@ru.ru
Subject: Re: [Bug #42669] 3.3-rc1: compiling problems nvme , l2cap_sock ,
 mc13892-regulator , and snd-pcsp don't work
From: David Miller <davem@davemloft.net>
In-Reply-To: <qCQH7HfZS8E.A.FVG.M9rRPB@chimera>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
	<qCQH7HfZS8E.A.FVG.M9rRPB@chimera>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 23 Feb 2012 15:19:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 23 Feb 2012 23:51:25 +0100 (CET)

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 3.2.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42669
> Subject		: 3.3-rc1: compiling problems  nvme , l2cap_sock , mc13892-regulator , and snd-pcsp don't work
> Submitter	: werner <w.landgraf@ru.ru>
> Date		: 2012-01-20 18:52 (35 days old)
> Message-ID	: <web-682421181@zbackend1.aha.ru>
> References	: http://marc.info/?l=linux-kernel&m=132708923719565&w=2

The l2cap_sock problem is fixed in the net GIT tree by commit:

--------------------
commit 4aa832c27edf902130f8bace1d42cf22468823fa
Author: Johan Hedberg <johan.hedberg@intel.com>
Date:   Sun Jan 8 22:51:16 2012 +0200

    Bluetooth: Remove bogus inline declaration from l2cap_chan_connect
    
    As reported by Dan Carpenter this function causes a Sparse warning and
    shouldn't be declared inline:
    
    include/net/bluetooth/l2cap.h:837:30 error: marked inline, but without a
    definition"
    
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
    Acked-by: Marcel Holtmann <marcel@holtmann.org>

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 68f5891..124f7cf 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -834,7 +834,7 @@ int l2cap_add_scid(struct l2cap_chan *chan,  __u16 scid);
 struct l2cap_chan *l2cap_chan_create(struct sock *sk);
 void l2cap_chan_close(struct l2cap_chan *chan, int reason);
 void l2cap_chan_destroy(struct l2cap_chan *chan);
-inline int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
+int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 								bdaddr_t *dst);
 int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len,
 								u32 priority);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index faf0b11..980abdb 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1120,7 +1120,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm, bdaddr
 	return c1;
 }
 
-inline int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid, bdaddr_t *dst)
+int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid, bdaddr_t *dst)
 {
 	struct sock *sk = chan->sk;
 	bdaddr_t *src = &bt_sk(sk)->src;
