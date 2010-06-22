Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab0FVXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:16:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49310 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab0FVXQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=IBwYDb6fT76MjLPQoSmlOA9z/0dNABSWDDcf7qBnXJKh0qEmbnypIexBCoZUBJ2w5/
         mWMgNvvHi857/I+QBizorkbkhBKfX1fUtY4IHviv0x4vOjAwLxUDCZbvV/LQDP4y6D8x
         kyOugU2sX/UOXAxxqZDy7IjSKucGXE9YhMFIc=
MIME-Version: 1.0
Date: Tue, 22 Jun 2010 16:16:53 -0700
Message-ID: <AANLkTilf41JrFwN1veRDifNA78S2LQ6SO0g3YLOONd2W@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at 
	00000000000000a0
From: Justin Mattock <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I remember ipsec was able to work cleanly on my machines probably
about 4/6 months ago
now I get this:


[  302.071077] BUG: unable to handle kernel NULL pointer dereference
at 00000000000000a0
[  302.071084] IP: [<ffffffff81387e0b>] xfrm_bundle_ok+0x14f/0x2e9
[  302.071094] PGD 13e695067 PUD 139c7e067 PMD 0
[  302.071100] Oops: 0000 [#1] SMP
[  302.071104] last sysfs file:
/sys/devices/pci0000:00/0000:00:15.0/0000:04:00.0/net/eth1/statistics/tx_bytes
[  302.071109] CPU 0
[  302.071111] Modules linked in: xfrm4_mode_transport sco xcbc bnep
rmd160 sha512_generic xt_tcpudp ipt_LOG iptable_nat nf_nat xt_state
nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
iptable_filter ip_tables x_tables firewire_ohci firewire_core evdev
lib80211_crypt_tkip uvcvideo videodev ohci1394 v4l1_compat button
thermal wl(P) nvidia(P) ohci_hcd forcedeth i2c_nforce2 aes_x86_64 lzo
lzo_compress ipcomp xfrm_ipcomp crypto_null sha256_generic cbc
des_generic cast5 blowfish serpent camellia twofish twofish_common ctr
ah4 esp4 authenc adm1021 raw1394 ieee1394 uhci_hcd ehci_hcd hci_uart
rfcomm btusb hidp l2cap bluetooth coretemp acpi_cpufreq processor
mperf appletouch applesmc
[  302.071185]
[  302.071189] Pid: 2603, comm: vncviewer Tainted: P
2.6.35-rc2-00001-g8dd40f7 #3 Mac-F2218FC8/iMac9,1
[  302.071193] RIP: 0010:[<ffffffff81387e0b>]  [<ffffffff81387e0b>]
xfrm_bundle_ok+0x14f/0x2e9
[  302.071199] RSP: 0018:ffff880139f4db58  EFLAGS: 00010246
[  302.071202] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  302.071206] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880139f48700
[  302.071209] RBP: ffff880139f4dbc8 R08: 0000000000000000 R09: ffff8801389cc574
[  302.071212] R10: dead000000200200 R11: ffff880139f4dc98 R12: ffff88012739a500
[  302.071216] R13: ffff88012739a780 R14: 0000000000000000 R15: ffff88012ed266c0
[  302.071220] FS:  00007f201be85740(0000) GS:ffff880001a00000(0000)
knlGS:0000000000000000
[  302.071224] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  302.071227] CR2: 00000000000000a0 CR3: 000000013b2a6000 CR4: 00000000000406f0
[  302.071230] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  302.071234] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  302.071238] Process vncviewer (pid: 2603, threadinfo
ffff880139f4c000, task ffff880131b1dc40)
[  302.071240] Stack:
[  302.071242]  ffff8801389366c0 ffffffff8168ff08 000000000000001c
000000000000000c
[  302.071248] <0> 0000000000000000 00000000004623c0 0000000000000000
0000000081606c40
[  302.071253] <0> ffff8801389cc480 ffff88012739a500 ffff88012ef80780
0000000000000000
[  302.071260] Call Trace:
[  302.071265]  [<ffffffff81387fba>] stale_bundle+0x15/0x1f
[  302.071270]  [<ffffffff81387fdc>] xfrm_dst_check+0x18/0x2e
[  302.071275]  [<ffffffff8131d02f>] __sk_dst_check+0x27/0x53
[  302.071281]  [<ffffffff8135172a>] ip_queue_xmit+0x3c/0x2ed
[  302.071286]  [<ffffffff8136405c>] ? tcp_connect+0x1d4/0x379
[  302.071290]  [<ffffffff8131eef3>] ? __skb_clone+0x29/0x100
[  302.071295]  [<ffffffff81363dc0>] tcp_transmit_skb+0x6e1/0x71f
[  302.071300]  [<ffffffff81364175>] tcp_connect+0x2ed/0x379
[  302.071305]  [<ffffffff81243739>] ? secure_tcp_sequence_number+0x55/0x6e
[  302.071310]  [<ffffffff813692ee>] tcp_v4_connect+0x3c4/0x419
[  302.071316]  [<ffffffff811952d2>] ? avc_has_perm+0x57/0x69
[  302.071321]  [<ffffffff81375030>] inet_stream_connect+0xa7/0x260
[  302.071326]  [<ffffffff8131aa26>] sys_connect+0x75/0x9b
[  302.071332]  [<ffffffff810e403c>] ? fd_install+0x52/0x5b
[  302.071338]  [<ffffffff81092983>] ? audit_syscall_entry+0x1b6/0x1e2
[  302.071342]  [<ffffffff8131a552>] ? sys_socket+0x3b/0x57
[  302.071348]  [<ffffffff81025f42>] system_call_fastpath+0x16/0x1b
[  302.071350] Code: 7d 58 41 80 bf c0 00 00 00 02 0f 85 98 01 00 00
41 8b 87 a8 00 00 00 41 39 85 b8 01 00 00 0f 85 84 01 00 00 49 8b 85
90 01 00 00 <8b> 80 a0 00 00 00 41 39 85 bc 01 00 00 0f 85 6a 01 00 00
83 7d
[  302.071400] RIP  [<ffffffff81387e0b>] xfrm_bundle_ok+0x14f/0x2e9
[  302.071405]  RSP <ffff880139f4db58>
[  302.071408] CR2: 00000000000000a0
[  302.071414] ---[ end trace b4323dbb88295950 ]---


starting a bisect, but might take some time....

-- 
Justin P. Mattock
