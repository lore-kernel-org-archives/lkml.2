Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab0LWFHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 00:07:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36591 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0LWFHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 00:07:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KBdbmAb1zuBdP6FX+LHrCHrfoOcSxzbR5xfsUvebSzIpOzeQTWIwHR1FfYd3iyy42F
         f0eXEUNiDDatMLA/jI2RR4r4jlDuYDwComr3EDbX332PpBr7tA6+v0KKUyUwA/Hr/J58
         +Z+81OLYDshq+TT6Nydx99/mTotrTIdcENsfI=
Subject: Re: 2.6.36.2 - loop on read /proc/net/tcp
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>, David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20101222134343.GC19998@beaver.vrungel.ru>
References: <20101222134343.GC19998@beaver.vrungel.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 06:07:26 +0100
Message-ID: <1293080846.2679.41.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 décembre 2010 à 16:43 +0300, Alexey Vlasov a écrit :
> Hi.
> 
> Has anyone seen such a bug at 2.6.36.2?
> # netstat -ntl
> Active Internet connections (only servers)
> Proto Recv-Q Send-Q Local Address           Foreign Address         State
> tcp        0      0 81.176.228.2:60608      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:8099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:8099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.7:8099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:8100       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:8100       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:8101       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:8101       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:20037      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:8102       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:8102       0.0.0.0:*               LISTEN
> tcp        0      0 127.0.0.1:3399          0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20040      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:38985      0.0.0.0:*               LISTEN
> tcp        0      0 0.0.0.0:873             0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20041      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20042      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:3306       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.3:3306       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.2:3306       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:9099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:9099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20043      0.0.0.0:*               LISTEN
> tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:9100       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:9100       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20044      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:33549      0.0.0.0:*               LISTEN
> ...
> First 30 lines are ok
> 
> but then go lines repeating in "eternal" loop:
> tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
> 
> # cat /proc/net/tcp
> ...
> It can hang an hour or so. but not always actually.
> 
> # i=0; while [ "$i" -lt "10" ]; do time wc -l /proc/net/tcp; let "i = $i + 1"; done
> 614782727 /proc/net/tcp
> 
> real    18m42.066s
> user    0m12.620s
> sys     18m25.890s
> 19443 /proc/net/tcp
> 
> real    0m0.040s
> user    0m0.000s
> sys     0m0.030s
> 19503 /proc/net/tcp
> 
> real    0m0.040s
> sys     0m0.030s
> 19502 /proc/net/tcp
> 
> real    0m0.041s
> user    0m0.000s
> sys     0m0.040s
> 28525 /proc/net/tcp
> 
> real    0m0.059s
> user    0m0.000s
> sys     0m0.050s
> 19463 /proc/net/tcp
> 
> real    0m0.048s
> user    0m0.000s
> sys     0m0.040s
> 19521 /proc/net/tcp
> 
> real    0m0.040s
> user    0m0.000s
> sys     0m0.030s
> 54394 /proc/net/tcp
> 
> real    0m0.104s
> user    0m0.000s
> sys     0m0.100s
> 19479 /proc/net/tcp
> 
> real    0m0.040s
> user    0m0.000s
> sys     0m0.030s
> 19481 /proc/net/tcp
> 
> real    0m0.040s
> user    0m0.000s
> sys     0m0.030s
> 

Hi Alexey

Thanks a lot for your report.

Here is a fix.

(Incidentaly, this means accesses to 0x40000000 addresses dont trigger
faults, since we never BUG() at this point)

David, this is a stable candidate. (2.6.29 +)

Thanks !

[PATCH] tcp: fix listening_get_next()

Alexey Vlasov found /proc/net/tcp could sometime loop and display
millions of sockets in LISTEN state.

In 2.6.29, when we converted TCP hash tables to RCU, we left two
sk_next() calls in listening_get_next().

We must instead use sk_nulls_next() to properly detect an end of chain.

Reported-by: Alexey Vlasov <renton@renton.name>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/tcp_ipv4.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e13da6d..d978bb2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2030,7 +2030,7 @@ static void *listening_get_next(struct seq_file *seq, void *cur)
 get_req:
 			req = icsk->icsk_accept_queue.listen_opt->syn_table[st->sbucket];
 		}
-		sk	  = sk_next(st->syn_wait_sk);
+		sk	  = sk_nulls_next(st->syn_wait_sk);
 		st->state = TCP_SEQ_STATE_LISTENING;
 		read_unlock_bh(&icsk->icsk_accept_queue.syn_wait_lock);
 	} else {
@@ -2039,7 +2039,7 @@ get_req:
 		if (reqsk_queue_len(&icsk->icsk_accept_queue))
 			goto start_req;
 		read_unlock_bh(&icsk->icsk_accept_queue.syn_wait_lock);
-		sk = sk_next(sk);
+		sk = sk_nulls_next(sk);
 	}
 get_sk:
 	sk_nulls_for_each_from(sk, node) {


