Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1DDDa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 23:30:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42583 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1DDDaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 23:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ISfMDSi3/6TkhnJOalghuVC664WjtINhI2oHgs46fgxYqxstmLJtIbsbYMNrqGOLLm
         ieokMozX3O7rdRB5vrS8LmGJax5s3o68MeJWKg2f3ihi9gpcb5LQcyFb1lhCHvoIWOMM
         MYge2xS86f9oS0JXtDxiBYMKSB+oQkmvPSIgU=
MIME-Version: 1.0
Reply-To: ben@iagu.net
In-Reply-To: <4D887B6A.2020102@redhat.com>
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>
	<20110318123031.GB6066@8bytes.org>
	<AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>
	<4D871F6C.40207@redhat.com>
	<AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>
	<AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>
	<4D875842.9050308@redhat.com>
	<AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
	<4D8773AA.8030408@redhat.com>
	<AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	<1300726498.2884.493.camel@edumazet-laptop>
	<4D8784A9.8040303@redhat.com>
	<1300727545.2884.513.camel@edumazet-laptop>
	<AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	<1300746429.2837.20.camel@edumazet-laptop>
	<1300777760.2837.38.camel@edumazet-laptop>
	<AANLkTik-Rt-Fy-2fKQTr2JBB9f7U2cbc0FmTZOoXc1+5@mail.gmail.com>
	<4D887B6A.2020102@redhat.com>
Date: Mon, 4 Apr 2011 09:15:23 +0545
X-Google-Sender-Auth: qrOp6PqjSmb7lWaItgHGXgbh5WQ
Message-ID: <BANLkTimHBGd+OLnWFMOm8HdFwgbZNYm8Ng@mail.gmail.com>
Subject: Re: [PATCH] posix-timers: RCU conversion
From: Ben Nagy <ben@iagu.net>
To: Avi Kivity <avi@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 4:20 PM, Avi Kivity <avi@redhat.com> wrote:
[...]
> Looks like the posix-timer issue is completely gone, to be replaced by the
> load balancer.
>
> Copying peterz.

Hi all,

I feel bad about such a big cc list, but I don't know who can be left out :/

Still got the performance issue with the load balancer.

Additionally, when trying to test with 48 VMs under load, they
consistently all lock up after a few minutes, which we traced as far
as ocfs2 dying. We're investigating it as an ocfs2 issue, and we'll
try and replicate on ext4 / nfs, but I just thought it might be
somehow related.

Apr  3 18:27:35 eax kernel: [16029.399507] ------------[ cut here ]------------
Apr  3 18:27:35 eax kernel: [16029.401408] kernel BUG at
/home/fuzzadmin/src/natty/source/fs/jbd2/journal.c:1610!
Apr  3 18:27:35 eax kernel: [16029.404541] invalid opcode: 0000 [#1] SMP
Apr  3 18:27:35 eax kernel: [16029.406289] last sysfs file:
/sys/devices/system/cpu/cpu47/cache/index2/shared_cpu_map
Apr  3 18:27:35 eax kernel: [16029.409453] CPU 36
Apr  3 18:27:35 eax kernel: [16029.409453] Modules linked in: ocfs2
quota_tree ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntr
ack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter
ip_tables x_tables bridge stp w83627ehf hwmon_vid ocfs2_dlmfs
ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue c
onfigfs ipmi_si ipmi_msghandler ib_srp scsi_transport_srp scsi_tgt
vesafb ib_ipoib ib_iser ib_umad iscsi_tcp rdma_ucm libiscsi_tcp
rdma_cm libiscsi ib_cm iw_cm scsi_transport_iscsi ib_addr ib
_sa ib_uverbs mlx4_ib ib_mad ib_core vhost_net amd64_edac_mod psmouse
edac_core sp5100_tco ghes joydev serio_raw hed edac_mce_amd k10temp
kvm_amd i2c_piix4 kvm lp parport usb_storage usbhid h
id uas igb ahci pata_atiixp libahci dca mlx4_core
Apr  3 18:27:35 eax kernel: [16029.409453]
Apr  3 18:27:35 eax kernel: [16029.409453] Pid: 1746, comm: ocfs2cmt
Not tainted 2.6.38-7-server #39 Supermicro H8QG6/H8QG6
Apr  3 18:27:35 eax kernel: [16029.409453] RIP:
0010:[<ffffffff8124905a>]  [<ffffffff8124905a>]
jbd2_journal_flush+0x17a/0x190
Apr  3 18:27:35 eax kernel: [16029.409453] RSP: 0018:ffff880404be3dc0
EFLAGS: 00010286
Apr  3 18:27:35 eax kernel: [16029.409453] RAX: 0000000000000029 RBX:
ffff88181593c000 RCX: 000000000000001e
Apr  3 18:27:35 eax kernel: [16029.409453] RDX: 00000000fffffffb RSI:
ffff880404be3cd0 RDI: ffff88181593c024
Apr  3 18:27:35 eax kernel: [16029.409453] RBP: ffff880404be3df0 R08:
ffff880404be2000 R09: 0000000000000000
Apr  3 18:27:35 eax kernel: [16029.409453] R10: 0000000000000000 R11:
0000000000000001 R12: 0000000000000e5d
Apr  3 18:27:35 eax kernel: [16029.409453] R13: ffff88181593c39c R14:
ffff88181593c024 R15: 0000000000000000
Apr  3 18:27:35 eax kernel: [16029.409453] FS:  00007f73affb7700(0000)
GS:ffff881627c00000(0000) knlGS:0000000000000000
Apr  3 18:27:35 eax kernel: [16029.736049] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Apr  3 18:27:35 eax kernel: [16029.736049] CR2: 0000000002f72000 CR3:
00000002f0d31000 CR4: 00000000000006e0
Apr  3 18:27:35 eax kernel: [16029.736049] DR0: 00000000000000a0 DR1:
0000000000000000 DR2: 0000000000000003
Apr  3 18:27:35 eax kernel: [16029.736049] DR3: 00000000000000b0 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr  3 18:27:35 eax kernel: [16029.736049] Process ocfs2cmt (pid:
1746, threadinfo ffff880404be2000, task ffff8803f72396e0)
Apr  3 18:27:35 eax kernel: [16029.736049] Stack:
Apr  3 18:27:35 eax kernel: [16029.736049]  0000000000000001
ffff8806155eb800 ffff8806155eb838 ffff8803f72396e0
Apr  3 18:27:35 eax kernel: [16029.736049]  ffff8806160cb000
ffff8806160cb160 ffff880404be3e40 ffffffffa042af12
Apr  3 18:27:35 eax kernel: [16029.736049]  0000000000000000
ffff8806155eb860 0000000000000286 ffff8806155eb828
Apr  3 18:27:35 eax kernel: [16029.736049] Call Trace:
Apr  3 18:27:35 eax kernel: [16029.736049]  [<ffffffffa042af12>]
ocfs2_commit_cache+0xc2/0x330 [ocfs2]
Apr  3 18:27:35 eax kernel: [16029.736049]  [<ffffffffa042b1e1>]
ocfs2_commit_thread+0x61/0x210 [ocfs2]
Apr  3 18:27:35 eax kernel: [16029.736049]  [<ffffffff81087870>] ?
autoremove_wake_function+0x0/0x40
Apr  3 18:27:35 eax kernel: [16029.736049]  [<ffffffffa042b180>] ?
ocfs2_commit_thread+0x0/0x210 [ocfs2]
Apr  3 18:27:35 eax kernel: [16029.736049]  [<ffffffff81087126>]
kthread+0x96/0xa0
Apr  3 18:27:35 eax kernel: [16029.736049]  [<ffffffff8100cde4>]
kernel_thread_helper+0x4/0x10
Apr  3 18:27:35 eax kernel: [16029.736049]  [<ffffffff81087090>] ?
kthread+0x0/0xa0
Apr  3 18:27:35 eax kernel: [16029.736049]  [<ffffffff8100cde0>] ?
kernel_thread_helper+0x0/0x10
Apr  3 18:27:35 eax kernel: [16029.736049] Code: c0 5b 41 5c 41 5d 41
5e 41 5f c9 c3 0f 1f 44 00 00 4c 8b 63 58 4d 85 e4 0f 85 d2 fe ff ff
f0 81 43 24 00 00 00 01 e9 da fe ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b
66 66 66 2e 0f 1f 84 00 00 00 00
Apr  3 18:27:35 eax kernel: [16029.736049] RIP  [<ffffffff8124905a>]
jbd2_journal_flush+0x17a/0x190
Apr  3 18:27:35 eax kernel: [16031.320082] ------------[ cut here ]------------

Thanks for any feedback...

Cheers,

ben
