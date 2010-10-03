Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0JCKy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 06:54:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40946 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab0JCKy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 06:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lpCBnaCW5fHOb5fu5oGbAUlzMq1Mj5V6LOXYF6xu9NrlupEMhBgfOqiPIW/AhktvzV
         sbre/Qxev05M01UCzvNpPyczlIshkx0hPmOWy03OVEyDPki6uQs3qioWQSZBLHzJVybB
         4fVIMsioMEJs1wkRwQCnWlwRm1YFNSc4kdS6E=
MIME-Version: 1.0
In-Reply-To: <4CA84DA1.1070206@extricom.com>
References: <4C232B13.5000706@extricom.com>
	<20100624.145225.70206491.davem@davemloft.net>
	<4C2855D4.5050507@extricom.com>
	<20100628.113336.112593735.davem@davemloft.net>
	<4C2A145D.1000702@extricom.com>
	<AANLkTikXj3cAkrMMUP2_TGSFYQY9=oPg8QxOU-jYUjnR@mail.gmail.com>
	<4CA84DA1.1070206@extricom.com>
Date: Sun, 3 Oct 2010 13:54:26 +0300
Message-ID: <AANLkTin-5tj1FT4bUZ99pXuvr812rN8Ta9zj7QAWLdJt@mail.gmail.com>
Subject: Re: [PATCH] gainfar.c : skb_over_panic (kernel-2.6.32.15)
From: emin ak <eminak71@gmail.com>
To: Eran Liberty <liberty@extricom.com>
Cc: David Miller <davem@davemloft.net>, galak@kernel.crashing.org,
        LKML <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/3 Eran Liberty <liberty@extricom.com>:
> Dear Amin Ak,
>
> A patch has been posted both to the most recent kernel tree at the time and
> to the long term 2.6.32.X branch. At which point it is out of mine and in
> the capable hands of the maintainers.
>
> If needs be, I am willing to repost the patches even though they are still
> out there and probably still fresh enough.
>
> If you apply them and solve your own private overpanic maybe "ack"ing the
> patch will expedite its trip into the kernel kingdom.
>
> -- Liberty
>
Hi Eran,
Firstly thanks for your answer. After my previous e-mail, I found that
your patch has been applied to linux-2.6.36-rc5 kernel, so that I have
tried this kernel with my development card (MPC8572DS) and run my test
at full line rate ip traffic. But sadly, it has crashed also. I'am not
sure this crashes related with skb recycling or the problem that you
solved with your patch, but looks like similar. I have report this bug
to the maillist today
(http://permalink.gmane.org/gmane.linux.kernel/1043818), but also
attached the crash logs at the end of this mail.
Do you think this crashes related with same problem as yours or caused
by another reason?
Thanks.
Emin

Crash type 1:
root@mpc8572ds:~# skb_over_panic: text:c0226280 len:1171 put:1171
head:eed6d000 data:eed63040 tail:0xeed6d4d3 end:0xeed63660 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:127!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=2 MPC8572 DS
last sysfs file: /sys/devices/pci0002:03/0002:03:00.0/subsystem_device
Modules linked in:
NIP: c023bdcc LR: c023bdcc CTR: c01f3ff8
REGS: effe7d70 TRAP: 0700   Not tainted  (2.6.36-rc5)
MSR: 00029000 <EE,ME,CE>  CR: 22028024  XER: 20000000
TASK = ef83e9a0[9] 'ksoftirqd/1' THREAD: ef856000 CPU: 1
GPR00: c023bdcc effe7e20 ef83e9a0 0000007c 00021000 ffffffff c01f7b98 c03ccf1c
GPR08: c03c69d4 c03f94b4 00c4e000 00000004 20028048 1001a108 ef211000 efb52d90
GPR16: efb52e38 efb52870 00000000 ef211800 00000008 00000009 efb52800 00000037
GPR24: ef24e180 ef2be040 00000000 ef211948 efb52b80 00000493 ef015940 ef386600
NIP [c023bdcc] skb_put+0x8c/0x94
LR [c023bdcc] skb_put+0x8c/0x94
Call Trace:
[effe7e20] [c023bdcc] skb_put+0x8c/0x94 (unreliable)
[effe7e30] [c0226280] gfar_clean_rx_ring+0x104/0x4b8
[effe7e90] [c02269dc] gfar_poll+0x3a8/0x60c
[effe7f60] [c024928c] net_rx_action+0xf8/0x1a4
[effe7fa0] [c0042524] __do_softirq+0xe0/0x178
[effe7ff0] [c000e59c] call_do_softirq+0x14/0x24
[ef857f50] [c0004840] do_softirq+0x90/0xa0
[ef857f70] [c00430e4] run_ksoftirqd+0xb4/0x164
[ef857fb0] [c00586b4] kthread+0x7c/0x80
[ef857ff0] [c000e9a8] kernel_thread+0x4c/0x68
Instruction dump:
81030098 2f800000 409e000c 3d20c037 3809a19c 3c60c037 7c8802a6 7d695b78
3863b010 90010008 4cc63182 4be016c5 <0fe00000> 48000000 9421fff0 7c0802a6
Kernel panic - not syncing: Fatal exception in interrupt

Crash type: 2

Faulting instruction address: 0xc026c1dc
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=2 MPC8572 DS
last sysfs file: /sys/devices/pci0002:03/0002:03:00.0/subsystem_device
Modules linked in:
NIP: c026c1dc LR: c026bfac CTR: 00000000
REGS: effebd00 TRAP: 0300   Not tainted  (2.6.36-rc5)
MSR: 00029000 <EE,ME,CE>  CR: 42028042  XER: 00000000
DEAR: 0000cad8, ESR: 00000000
TASK = ef83cde0[3] 'ksoftirqd/0' THREAD: ef84a000 CPU: 0
GPR00: 00000005 effebdb0 ef83cde0 00000000 000001b9 00000000 c1008060 00000000
GPR08: 02c3f605 0000ca00 000005b9 0000ca00 b653a6c7 7af823f0 ef217000 efbab590
GPR16: efbab638 efbab070 00000000 ef217800 00000008 00000018 efbab000 00000028
GPR24: c03f971c c0410000 c0400000 c03f94b4 effea000 ef316e40 00000000 eecb685e
NIP [c026c1dc] ip_rcv+0x3f8/0x808
LR [c026bfac] ip_rcv+0x1c8/0x808
Call Trace:
[effebdb0] [c026c204] ip_rcv+0x420/0x808 (unreliable)
[effebde0] [c02482dc] __netif_receive_skb+0x2f8/0x324
[effebe10] [c02483a4] netif_receive_skb+0x9c/0xb0
[effebe30] [c0226308] gfar_clean_rx_ring+0x18c/0x4b8
[effebe90] [c02269dc] gfar_poll+0x3a8/0x60c
[effebf60] [c024928c] net_rx_action+0xf8/0x1a4
[effebfa0] [c0042524] __do_softirq+0xe0/0x178
[effebff0] [c000e59c] call_do_softirq+0x14/0x24
[ef84bf50] [c0004840] do_softirq+0x90/0xa0
[ef84bf70] [c00430e4] run_ksoftirqd+0xb4/0x164
[ef84bfb0] [c00586b4] kthread+0x7c/0x80
[ef84bff0] [c000e9a8] kernel_thread+0x4c/0x68
Instruction dump:
8148003c 318a0001 7d690194 91680038 9188003c 4bfffd78 7fa3eb78 48002a29
2f830000 40beff50 817d0048 5569003c <a00900d8> 2f800005 419e0034 2f800003
Kernel panic - not syncing: Fatal exception in interrupt
