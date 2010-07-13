Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab0GMQw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:52:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34622 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0GMQwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type;
        b=VtFx/v5ZkLTZleiPbcmg91GIoogMtlMwL0oT34cNNQaGHQfDWko8E2k5R6mN2M2xNO
         0w2efSdinLvftqbKjyPoprCZWOzMzULn1GtINWxTkPMKdsJ4YePIZ+APmuS6JaBfXzFc
         n32slbViXfsmMnOAGb4870J4S5gb54O8B8GfQ=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C145Kgawfr7AhM78SwADGJZ7/tn2mYU8wIKslf//SbesHkXjk6AlYhvfFY4+pFbVHK
         j6KvdsQeh7+K9H2KL7rVDCFlmYTF77+04S+1guvD+c4ZKaMKlenbm5hpMXC9f5i1x/pz
         AquHkfVDSmFWJ39xBA09MZIdkckAaWrwWIKC8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007131745230.3321@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
	<alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
	<alpine.LFD.2.00.1003121124120.22855@localhost.localdomain>
	<alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
	<alpine.LFD.2.00.1004071619490.32352@localhost.localdomain>
	<alpine.LFD.2.00.1004271744280.2951@localhost.localdomain>
	<alpine.LFD.2.00.1004301156590.2951@localhost.localdomain>
	<alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
	<alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>
	<alpine.LFD.2.00.1007131745230.3321@localhost.localdomain>
Date: Tue, 13 Jul 2010 18:52:18 +0200
Message-ID: <AANLkTin5dJXFZyfKxuM6p2aR30U1P5m0v2mDHGwygOR8@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33.6-rt26
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> Enjoy !
>

I hit this with rt26. (Quite possible is on vanilla as well, will
build a kernel soemtime soon and try)

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.33.6-rt26 #36
-------------------------------------------------------
iperf/1629 is trying to acquire lock:
 (slock-AF_INET){+.+...}, at: [<ffffffff8135a4fa>] release_sock+0x30/0x108

but task is already holding lock:
 (&lock->lock){+.+...}, at: [<ffffffff813cd6cc>] ipt_do_table+0x118/0x650

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&lock->lock){+.+...}:
       [<ffffffff810697e7>] lock_acquire+0xd6/0xfa
       [<ffffffff813fcfaa>] rt_spin_lock+0x31/0x38
       [<ffffffffa00ba8ef>] nf_nat_get_offset+0x42/0x6b [nf_nat]
       [<ffffffff8138b2ba>] tcp_packet+0x659/0xd5b
       [<ffffffff81387eb9>] nf_conntrack_in+0x445/0x4fc
       [<ffffffff813ca933>] ipv4_conntrack_local+0x3b/0x44
       [<ffffffff81384c22>] nf_iterate+0x41/0x84
       [<ffffffff81384cd8>] nf_hook_slow+0x73/0xdb
       [<ffffffff813970b4>] nf_hook_thresh.clone.0+0x3c/0x45
       [<ffffffff81397136>] __ip_local_out+0x79/0x7b
       [<ffffffff81397149>] ip_local_out+0x11/0x22
       [<ffffffff81397407>] ip_push_pending_frames+0x2ad/0x30b
       [<ffffffff81398a41>] ip_send_reply+0x21a/0x259
       [<ffffffff813acdf1>] tcp_v4_send_reset+0x1c8/0x1eb
       [<ffffffff813b0367>] tcp_v4_rcv+0x500/0x661
       [<ffffffff8139400a>] ip_local_deliver_finish+0x14d/0x1c3
       [<ffffffff813940f2>] ip_local_deliver+0x72/0x7c
       [<ffffffff81393ac3>] ip_rcv_finish+0x31a/0x346
       [<ffffffff81393d29>] ip_rcv+0x23a/0x268
       [<ffffffff81366862>] netif_receive_skb+0x3fa/0x424
       [<ffffffffa023fb41>] br_handle_frame_finish+0x105/0x13d [bridge]
       [<ffffffffa023fd08>] br_handle_frame+0x18f/0x1a7 [bridge]
       [<ffffffff81366792>] netif_receive_skb+0x32a/0x424
       [<ffffffff813669d4>] napi_skb_finish+0x24/0x3b
       [<ffffffff81366e83>] napi_gro_receive+0x2a/0x2f
       [<ffffffff812d03b9>] sky2_poll+0x86e/0xaef
       [<ffffffff81366fcc>] net_rx_action+0xa3/0x1f1
       [<ffffffff81044a02>] run_ksoftirqd+0x14e/0x254
       [<ffffffff8105975f>] kthread+0x88/0x90
       [<ffffffff81009844>] kernel_thread_helper+0x4/0x10

-> #0 (slock-AF_INET){+.+...}:
       [<ffffffff8106941a>] __lock_acquire+0x9f1/0xce8
       [<ffffffff810697e7>] lock_acquire+0xd6/0xfa
       [<ffffffff813fcfaa>] rt_spin_lock+0x31/0x38
       [<ffffffff8135a4fa>] release_sock+0x30/0x108
       [<ffffffff813a012a>] tcp_recvmsg+0x8b8/0x9a3
       [<ffffffff81359864>] sock_common_recvmsg+0x37/0x48
       [<ffffffff81357178>] __sock_recvmsg+0x6d/0x78

(Just run iperf as server and test it from another system)

thanks,
Dhaval
