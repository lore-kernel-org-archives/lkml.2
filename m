Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0IVGiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 02:38:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58087 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0IVGix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 02:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=up1N6fcvJv02FeYg+rHm89U4lbX6GSUXOeQXmJYmPxOlXwX8gKlbqbkKwEcW98u617
         vjFDU+/nQCet44JIcuoS9WXlGqZirawX5ru0Dp07Bv3OiHPTV69lBu6pSshR1yYsp2lp
         720AmsPgxIK/eN22RxqeZp5gg7EiUjq5URdLA=
Subject: Re: 2.6.36-rc5-git1 -- include/linux/netpoll.h:67 invoked
 rcu_dereference_check() without protection!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Miles Lane <miles.lane@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <AANLkTi=g-6ywz4AoGyBKTp_gfFW6jkBrmGUW5E_Um9LX@mail.gmail.com>
References: <AANLkTi=g-6ywz4AoGyBKTp_gfFW6jkBrmGUW5E_Um9LX@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 08:38:44 +0200
Message-ID: <1285137524.6378.160.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 septembre 2010 à 00:22 -0400, Miles Lane a écrit :
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> include/linux/netpoll.h:67 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by avahi-daemon/1597:
>  #0:  (sk_lock-AF_INET6){+.+.+.}, at: [<ffffffffa03673b7>]
> udpv6_sendmsg+0x6c2/0x9e6 [ipv6]
> 
> stack backtrace:
> Pid: 1597, comm: avahi-daemon Not tainted 2.6.36-rc5 #13
> Call Trace:
>  [<ffffffff810618d7>] lockdep_rcu_dereference+0x9d/0xa6
>  [<ffffffff8129d543>] netif_rx+0x4e/0x1a7
>  [<ffffffff8102fe4e>] ? get_parent_ip+0x11/0x41
>  [<ffffffff8129d7e3>] netif_rx_ni+0x1e/0x58
>  [<ffffffffa0352d50>] ip6_dev_loopback_xmit+0xc0/0xc7 [ipv6]
>  [<ffffffffa0352ef0>] ip6_finish_output2+0x199/0x3b6 [ipv6]
>  [<ffffffffa035401c>] ip6_finish_output+0xf0f/0xf27 [ipv6]
>  [<ffffffff8131e08a>] ? csum_partial_copy_from_user+0xb4/0xea
>  [<ffffffff812968a8>] ? csum_partial_copy_fromiovecend+0x178/0x1bd
>  [<ffffffffa035418c>] ip6_output+0x158/0x161 [ipv6]
>  [<ffffffff8102fe4e>] ? get_parent_ip+0x11/0x41
>  [<ffffffffa035262d>] ip6_local_out+0x5d/0x62 [ipv6]
>  [<ffffffffa0352a98>] ip6_push_pending_frames+0x466/0x524 [ipv6]
>  [<ffffffffa0366a93>] udp_v6_push_pending_frames+0x27f/0x2fb [ipv6]
>  [<ffffffffa03673b7>] ? udpv6_sendmsg+0x6c2/0x9e6 [ipv6]
>  [<ffffffffa03674ba>] udpv6_sendmsg+0x7c5/0x9e6 [ipv6]
>  [<ffffffff812fb634>] ? inet_sendmsg+0x0/0x11f
>  [<ffffffff812fb746>] inet_sendmsg+0x112/0x11f
>  [<ffffffff812fb634>] ? inet_sendmsg+0x0/0x11f
>  [<ffffffff8128ca91>] sock_sendmsg+0xe7/0x108
>  [<ffffffff810a4c3b>] ? might_fault+0x63/0xb3
>  [<ffffffff810a4c84>] ? might_fault+0xac/0xb3
>  [<ffffffff810a4c3b>] ? might_fault+0x63/0xb3
>  [<ffffffff8128d346>] sys_sendmsg+0x24f/0x2d6
>  [<ffffffff8102fe4e>] ? get_parent_ip+0x11/0x41
>  [<ffffffff81031ef7>] ? sub_preempt_count+0x92/0xa6
>  [<ffffffff810570ce>] ? __srcu_read_unlock+0x3b/0x57
>  [<ffffffff81001f9c>] ? sysret_check+0x27/0x62
>  [<ffffffff81001f6b>] system_call_fastpath+0x16/0x1b#

Oh well.

Thanks for the report. Could you please test following patch ?


[PATCH] rcu: rcu_dereference_bh() is hard irq safe

rcu_dereference_bh() doesnt know yet about hard irq being disabled, so
lockdep can trigger in netpoll_rx() after commit f0f9deae9e7c4 (netpoll:
Disable IRQ around RCU dereference in netpoll_rx)

Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9fbc54a..435c502 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -454,7 +454,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * Makes rcu_dereference_check() do the dirty work.
  */
 #define rcu_dereference_bh(p) \
-		rcu_dereference_check(p, rcu_read_lock_bh_held())
+		rcu_dereference_check(p, rcu_read_lock_bh_held() || in_irq())
 
 /**
  * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched


