Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0HQEy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:54:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39473 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0HQEyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N+4J9X4vNqWP2QIDC0WXwLAkCo2NkNEmd0VnYjHE5+fp4+KHZl+j5Z34vSDUfaEnBJ
         0Z//yyhxWpf9Gwrt9GZg4moZxE7Gfp/yf1FURMSdhzaHpfDC9jrOll6KYh0dVhmgCyie
         KlAsa4s+U6nHPK8q9WF4h7GEKm4hUrXE6QvZ0=
Subject: Re: 2.6.36-rc1 - iptables inconsistent lock state
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ivan Bulatovic <combuster@gmx.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1282002221.2247.8.camel@localhost.localdomain>
References: <1282002221.2247.8.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 06:54:18 +0200
Message-ID: <1282020858.2487.567.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 août 2010 à 01:43 +0200, Ivan Bulatovic a écrit :
> I've compiled 2.6.36-rc1 with
> 
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> 
> and when I try to load ufw I get this info in dmesg:
> 
> [   30.687708] =================================
> [   30.688013] [ INFO: inconsistent lock state ]
> [   30.688013] 2.6.36-rc1-RC #1
> [   30.688013] ---------------------------------
> [   30.688013] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> [   30.688013] iptables/1853 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [   30.688013]  (&(&lock->lock)->rlock){+.?...}, at:
> [<ffffffff8133b244>] get_counters+0x9d/0x146
> [   30.688013] {IN-SOFTIRQ-W} state was registered at:
> [   30.688013]   [<ffffffff810681f5>] __lock_acquire+0x635/0x16a3
> [   30.688013]   [<ffffffff81069794>] lock_acquire+0xef/0x115
> [   30.688013]   [<ffffffff813a59c9>] _raw_spin_lock+0x36/0x45
> [   30.688013]   [<ffffffff8133b394>] ipt_do_table+0xa7/0x3af
> [   30.688013]   [<ffffffff8133d6c3>] iptable_mangle_hook+0x105/0x11a
> [   30.688013]   [<ffffffff812eb69b>] nf_iterate+0x41/0x84
> [   30.688013]   [<ffffffff812eb776>] nf_hook_slow+0x98/0x13a
> [   30.688013]   [<ffffffff812fca48>] ip_rcv+0x26e/0x2aa
> [   30.688013]   [<ffffffff812c79fa>] __netif_receive_skb+0x47f/0x4df
> [   30.688013]   [<ffffffff812c85a8>] netif_receive_skb+0x125/0x134
> [   30.688013]   [<ffffffffa028f4b9>] rtl8169_rx_interrupt.clone.36
> +0x345/0x428 [r8169]
> [   30.688013]   [<ffffffffa028f6cb>] rtl8169_poll+0x30/0x16f [r8169]
> [   30.688013]   [<ffffffff812ca138>] net_rx_action+0xbb/0x201
> [   30.688013]   [<ffffffff81041809>] __do_softirq+0x126/0x218
> [   30.688013]   [<ffffffff8100394c>] call_softirq+0x1c/0x28
> [   30.688013]   [<ffffffff81004ef7>] do_softirq+0x38/0x81
> [   30.688013]   [<ffffffff810419b6>] irq_exit+0x45/0x90
> [   30.688013]   [<ffffffff81004b9c>] do_IRQ+0xac/0xc3
> [   30.688013]   [<ffffffff813a6693>] ret_from_intr+0x0/0xf
> [   30.688013]   [<ffffffff8129fe97>] cpuidle_idle_call+0xa9/0x13e
> [   30.688013]   [<ffffffff81001189>] cpu_idle+0x65/0xed
> [   30.688013]   [<ffffffff81393d0f>] rest_init+0xf3/0xfa
> [   30.688013]   [<ffffffff8169bb91>] start_kernel+0x398/0x3a3
> [   30.688013]   [<ffffffff8169b2a1>] x86_64_start_reservations
> +0xb1/0xb5
> [   30.688013]   [<ffffffff8169b38e>] x86_64_start_kernel+0xe9/0xf0
> [   30.688013] irq event stamp: 3481
> [   30.688013] hardirqs last  enabled at (3481): [<ffffffff81041344>]
> local_bh_enable+0xb8/0xd7
> [   30.688013] hardirqs last disabled at (3479): [<ffffffff810412de>]
> local_bh_enable+0x52/0xd7
> [   30.688013] softirqs last  enabled at (3480): [<ffffffff8133b217>]
> get_counters+0x70/0x146
> [   30.688013] softirqs last disabled at (3478): [<ffffffff8133b1d5>]
> get_counters+0x2e/0x146
> [   30.688013] 
> [   30.688013] other info that might help us debug this:
> [   30.688013] 2 locks held by iptables/1853:
> [   30.688013]  #0:  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff81302841>]
> ip_getsockopt+0x5d/0xa3
> [   30.688013]  #1:  (&xt[i].mutex){+.+.+.}, at: [<ffffffff812f53b0>]
> xt_find_table_lock+0x3b/0x177
> [   30.688013] 
> [   30.688013] stack backtrace:
> [   30.688013] Pid: 1853, comm: iptables Not tainted 2.6.36-rc1-RC #1
> [   30.688013] Call Trace:
> [   30.688013]  [<ffffffff8106767f>] print_usage_bug+0x1a7/0x1b8
> [   30.688013]  [<ffffffff8100d908>] ? save_stack_trace+0x2a/0x47
> [   30.688013]  [<ffffffff81066db6>] ? check_usage_backwards+0x0/0xd1
> [   30.688013]  [<ffffffff81067979>] mark_lock+0x2e9/0x530
> [   30.688013]  [<ffffffff81068278>] __lock_acquire+0x6b8/0x16a3
> [   30.688013]  [<ffffffff810eb115>] ? __kmalloc_node+0x14f/0x213
> [   30.688013]  [<ffffffff8133b244>] ? get_counters+0x9d/0x146
> [   30.688013]  [<ffffffff81069794>] lock_acquire+0xef/0x115
> [   30.688013]  [<ffffffff8133b244>] ? get_counters+0x9d/0x146
> [   30.688013]  [<ffffffff813a59c9>] _raw_spin_lock+0x36/0x45
> [   30.688013]  [<ffffffff8133b244>] ? get_counters+0x9d/0x146
> [   30.688013]  [<ffffffff81041344>] ? local_bh_enable+0xb8/0xd7
> [   30.688013]  [<ffffffff8133b244>] get_counters+0x9d/0x146
> [   30.688013]  [<ffffffff8133be22>] alloc_counters.clone.4+0x2d/0x41
> [   30.688013]  [<ffffffff8133c205>] do_ipt_get_ctl+0x117/0x363
> [   30.688013]  [<ffffffff813a4b28>] ? mutex_unlock+0x9/0xb
> [   30.688013]  [<ffffffff812bb050>] ? lock_sock_nested+0x6e/0x79
> [   30.688013]  [<ffffffff812ecae1>] nf_sockopt+0x53/0x7f
> [   30.688013]  [<ffffffff812ecb20>] nf_getsockopt+0x13/0x15
> [   30.688013]  [<ffffffff81302858>] ip_getsockopt+0x74/0xa3
> [   30.688013]  [<ffffffff8131cfc7>] raw_getsockopt+0x18/0x26
> [   30.688013]  [<ffffffff812ba560>] sock_common_getsockopt+0xf/0x11
> [   30.688013]  [<ffffffff812b9a4b>] sys_getsockopt+0x75/0x96
> [   30.688013]  [<ffffffff810cff9f>] ? handle_mm_fault+0x32e/0x74b
> [   30.688013]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
> 

Yes, this is the third time it is reported here ;)

http://marc.info/?l=linux-kernel&m=128199018321130&w=2

Thanks


