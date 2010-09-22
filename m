Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0IVGsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 02:48:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0IVGsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 02:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AXeXpZLH+1b/tgwsZDFrJlxFohyhwbvHG4f/7eNgLtpC5fdQg9J21kDElTQVeN1J5y
         MZy6hOg1r7ehPfLgXuuDOPVUMvy3mM1gpjaEUrjoUwQoajloGMZyB6yEbNJUL14OsexJ
         jtnzs03SqESsyFC+aLWNI7PX6tTshdz/4un2w=
Subject: Re: tcp_fastretrans_alert since 2.6.32 ?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sunny <sunyucong@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
In-Reply-To: <AANLkTinnaA3Qgny45BRyW3i5u+nXn1XgWwkxA_QbN8xN@mail.gmail.com>
References: <AANLkTinnaA3Qgny45BRyW3i5u+nXn1XgWwkxA_QbN8xN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 08:48:46 +0200
Message-ID: <1285138126.6378.174.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC netdev and Ilpo

Le mardi 21 septembre 2010 à 23:37 -0700, Sunny a écrit :
> Hi,
> 
> After upgrading to the latest ubuntu kernel, I started to have this
> alert showing up, this is a vm running on ESXi host with vmxnet3
> adapter, mainly serving large traffic ~70Mbps towards overboard
> customers, so I expect packet loss and retrans is pretty high. So I'm
> posting to ask whether others been seeing the same issue? When this
> happens, machine freeze several seconds for about three times in a row
> then seems to start working again.
> 
> Please cc me on the thread, thanks in advance.
> 
> 
> [212670.327617] ------------[ cut here ]------------
> [212670.327689] WARNING: at
> /build/buildd/linux-2.6.32/net/ipv4/tcp_input.c:2919 tcp_fastret
> rans_alert+0x3f9/0xd90()
> [212670.327692] Hardware name: VMware Virtual Platform
> [212670.327693] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
> ufs qnx4 hfsplus hfs  minix ntfs vfat msdos fat jfs xfs exportfs
> reiserfs sch_sfq cls_u32 sch_htb nf_conntrack_ipv 6 ip6table_filter
> ip6_tables xt_tcpudp xt_state xt_multiport iptable_filter iptable_nat
> nf_n at nf_conntrack_ipv4 sit nf_conntrack nf_defrag_ipv4 tunnel4
> ip_tables x_tables acpiphp ppde v psmouse parport_pc serio_raw fbcon
> tileblit font bitblit softcursor vmxnet3 vga16fb vgasta te lp parport
> floppy vmw_pvscsi
> [212670.327741] Pid: 0, comm: swapper Not tainted 2.6.32-24-server #42-Ubuntu
> [212670.327742] Call Trace:
> [212670.327744]  <IRQ>  [<ffffffff81066dab>] warn_slowpath_common+0x7b/0xc0
> [212670.327754]  [<ffffffff81066e04>] warn_slowpath_null+0x14/0x20
> [212670.327757]  [<ffffffff814b98f9>] tcp_fastretrans_alert+0x3f9/0xd90
> [212670.327759]  [<ffffffff814bad24>] tcp_ack+0x284/0x6b0
> [212670.327762]  [<ffffffff814bbab0>] tcp_rcv_established+0x400/0x730
> [212670.327766]  [<ffffffff814c3553>] tcp_v4_do_rcv+0xf3/0x160
> [212670.327769]  [<ffffffff814c4ca5>] tcp_v4_rcv+0x5b5/0x7e0
> [212670.327772]  [<ffffffff814a2c00>] ? ip_local_deliver_finish+0x0/0x2d0
> [212670.327776]  [<ffffffff8149a6b4>] ? nf_hook_slow+0x74/0x100
> [212670.327779]  [<ffffffff814a2c00>] ? ip_local_deliver_finish+0x0/0x2d0
> [212670.327781]  [<ffffffff814a2cdd>] ip_local_deliver_finish+0xdd/0x2d0
> [212670.327783]  [<ffffffff814a2f60>] ip_local_deliver+0x90/0xa0
> [212670.327785]  [<ffffffff814a241d>] ip_rcv_finish+0x12d/0x440
> [212670.327787]  [<ffffffff814a29a5>] ip_rcv+0x275/0x360
> [212670.327794]  [<ffffffff8147319a>] netif_receive_skb+0x38a/0x5d0
> [212670.327801]  [<ffffffffa005203c>]
> vmxnet3_rq_rx_complete+0x23c/0x610 [vmxnet3]
> [212670.327806]  [<ffffffffa005245f>] vmxnet3_do_poll+0x4f/0xf0 [vmxnet3]
> [212670.327809]  [<ffffffffa005252d>] vmxnet3_poll+0x2d/0x60 [vmxnet3]
> [212670.327816]  [<ffffffff810397a9>] ? default_spin_lock_flags+0x9/0x10
> [212670.327820]  [<ffffffff81473c8f>] net_rx_action+0x10f/0x250
> [212670.327824]  [<ffffffff8106e2f7>] __do_softirq+0xb7/0x1e0
> [212670.327828]  [<ffffffff810c4d40>] ? handle_IRQ_event+0x60/0x170
> [212670.327833]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
> [212670.327836]  [<ffffffff81015cb5>] do_softirq+0x65/0xa0
> [212670.327837]  [<ffffffff8106e195>] irq_exit+0x85/0x90
> [212670.327845]  [<ffffffff8155fd45>] do_IRQ+0x75/0xf0
> [212670.327848]  [<ffffffff81013b13>] ret_from_intr+0x0/0x11
> [212670.327849]  <EOI>  [<ffffffff81038acb>] ? native_safe_halt+0xb/0x10
> [212670.327855]  [<ffffffff8101b69d>] ? default_idle+0x3d/0x90
> [212670.327860]  [<ffffffff81011e63>] ? cpu_idle+0xb3/0x110
> [212670.327867]  [<ffffffff81552b53>] ? start_secondary+0xa8/0xaa
> [212670.327869] ---[ end trace e26694ca94def524 ]---
> 
> 
> Here's netstat -s output
> 
> Ip:
>     362267935 total packets received
>     0 forwarded
>     0 incoming packets discarded
>     362257901 incoming packets delivered
>     326868094 requests sent out
>     9 fragments dropped after timeout
>     2777 reassemblies required
>     1357 packets reassembled ok
>     9 packet reassembles failed
>     490 fragments received ok
>     1034 fragments created
> Icmp:
>     22430 ICMP messages received
>     283 input ICMP message failed.
>     ICMP input histogram:
>         destination unreachable: 17113
>         timeout in transit: 613
>         redirects: 9
>         echo requests: 4685
>         echo replies: 10
>     7383 ICMP messages sent
>     0 ICMP messages failed
>     ICMP output histogram:
>         destination unreachable: 2695
>         echo request: 11
>         echo replies: 4677
> IcmpMsg:
>         InType0: 10
>         InType3: 17113
>         InType5: 9
>         InType8: 4685
>         InType11: 613
>         OutType0: 4677
>         OutType3: 2695
>         OutType8: 11
> Tcp:
>     6563076 active connections openings
>     1610183 passive connection openings
>     1646225 failed connection attempts
>     75246 connection resets received
>     1141 connections established
>     361192315 segments received
>     323797760 segments send out
>     1997456 segments retransmited
>     12990 bad segments received.
>     1851272 resets sent
> Udp:
>     4138313 packets received
>     186 packets to unknown port received.
>     0 packet receive errors
>     4161268 packets sent
> UdpLite:
> TcpExt:
>     5096 invalid SYN cookies received
>     167 resets received for embryonic SYN_RECV sockets
>     58826 packets pruned from receive queue because of socket buffer overrun
>     312 packets pruned from receive queue
>     19 packets dropped from out-of-order queue because of socket buffer overrun
>     365 ICMP packets dropped because they were out-of-window
>     2712111 TCP sockets finished time wait in fast timer
>     82068 time wait sockets recycled by time stamp
>     311 packets rejects in established connections because of timestamp
>     11516250 delayed acks sent
>     6415 delayed acks further delayed because of locked socket
>     Quick ack mode was activated 208750 times
>     41789 packets directly queued to recvmsg prequeue.
>     1 bytes directly in process context from backlog
>     2969 bytes directly received in process context from prequeue
>     155660989 packet headers predicted
>     55448128 acknowledgments not containing data payload received
>     89389461 predicted acknowledgments
>     9544 times recovered from packet loss due to fast retransmit
>     585991 times recovered from packet loss by selective acknowledgements
>     710 bad SACK blocks received
>     Detected reordering 1944 times using FACK
>     Detected reordering 26599 times using SACK
>     Detected reordering 267 times using reno fast retransmit
>     Detected reordering 1819 times using time stamp
>     3169 congestion windows fully recovered without slow start
>     26810 congestion windows partially recovered using Hoe heuristic
>     14402 congestion windows recovered without slow start by DSACK
>     40392 congestion windows recovered without slow start after partial ack
>     115772 TCP data loss events
>     TCPLostRetransmit: 5320
>     1922 timeouts after reno fast retransmit
>     69095 timeouts after SACK recovery
>     11101 timeouts in loss state
>     1151834 fast retransmits
>     74479 forward retransmits
>     225380 retransmits in slow start
>     275631 other TCP timeouts
>     2606 classic Reno fast retransmits failed
>     30507 SACK retransmits failed
>     4862645 packets collapsed in receive queue due to low socket buffer
>     260934 DSACKs sent for old packets
>     5109 DSACKs sent for out of order packets
>     95650 DSACKs received
>     819 DSACKs for out of order packets received
>     28142 connections reset due to unexpected data
>     22325 connections reset due to early user close
>     85423 connections aborted due to timeout
>     TCPSACKDiscard: 2319
>     TCPDSACKIgnoredOld: 52587
>     TCPDSACKIgnoredNoUndo: 29859
>     TCPSpuriousRTOs: 2605
>     TCPSackShifted: 3539688
>     TCPSackMerged: 3241543
>     TCPSackShiftFallback: 8938458
> IpExt:
>     InMcastPkts: 2105
>     InBcastPkts: 12
>     InOctets: 1670966745
>     OutOctets: -417434189
>     InMcastOctets: 58940
>     InBcastOctets: 1792


