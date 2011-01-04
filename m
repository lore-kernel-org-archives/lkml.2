Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1ADOz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:55:29 -0500
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:55508 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab1ADOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:55:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=b/pVFM0mAikqaSNsxdgZ85twa28LgDXhrgxnT9xEaCDaIiV8IPmd01j6q5NnsLNm;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D2334B5.1060408@earthlink.net>
Date: Tue, 04 Jan 2011 09:54:45 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: panic in tg3 driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec7957e6d90cbbb105f8d986a5f033fd72f2350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


The hardware is an Acrosser AR-M0898B micro box.
  lspci
00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro 
Host Bridge
00:00.1 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro 
Host Bridge
00:00.2 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro 
Host Bridge
00:00.3 Host bridge: VIA Technologies, Inc. PT890 Host Bridge
00:00.4 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro 
Host Bridge
00:00.7 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro 
Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237/VX700 PCI Bridge
00:0f.0 IDE interface: VIA Technologies, Inc. VT8251 Serial ATA 
Controller (rev
20)
00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/
C PIPC Bus Master IDE (rev 07)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller
  (rev 91)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller
  (rev 91)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller
  (rev 91)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller
  (rev 91)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 90)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8251 PCI to ISA Bridge
00:11.7 Host bridge: VIA Technologies, Inc. VT8251 Ultra VLINK Controller
00:13.0 Host bridge: VIA Technologies, Inc. VT8251 Host Bridge
00:13.1 PCI bridge: VIA Technologies, Inc. VT8251 PCI to PCI Bridge
02:08.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 02)
02:09.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 02)
80:00.0 PCI bridge: VIA Technologies, Inc. VT8251 PCIE Root Port
80:00.1 PCI bridge: VIA Technologies, Inc. VT8251 PCIE Root Port
81:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5906M Fast 
Ethernet
  PCI Express (rev 02)
82:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5906M Fast 
Ethernet
  PCI Express (rev 02)

Kernel 2.6.36-2.el5.elrepo on an i686

When I try to ifconfig either of the BCM5906M ports the system panics.

Ideas, fixes ?

[root@Z1010 ~]# modprobe tg3
[root@Z1010 ~]# ifconfig eth2 2.2.2.2/24
------------[ cut here ]------------
kernel BUG at drivers/net/tg3.c:4365!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/class/net/eth3/address
Modules linked in: tg3 xt_tcpudp ipt_LOG xt_limit xt_state 
iptable_mangle af_ke]

Pid: 20303, comm: kworker/0:2 Not tainted 2.6.36-2.el5.elrepo #1 
CN700-8251/
EIP: 0060:[<e1c62f19>] EFLAGS: 00010202 CPU: 0
EIP is at tg3_tx_recover+0x1e/0x53 [tg3]
EAX: deece4c0 EBX: dfa9c000 ECX: deece4c0 EDX: ffffffff
ESI: deece4c0 EDI: deece500 EBP: c1801f38 ESP: c1801f30
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kworker/0:2 (pid: 20303, ti=c1801000 task=df0105d0 task.ti=dee62000)
Stack:
  dfa9c000 00000000 c1801f6c e1c630be c1801f6c deece4c0 00000840 00000000
<0> df251cc0 00000005 00000000 df979800 deece500 deece4c0 00000040 c1801f94
<0> e1c661e5 00000000 00000040 c1801f88 e09df1d2 00000000 deece500 dfab4000
Call Trace:
  [<e1c630be>] ? tg3_tx+0x157/0x1a2 [tg3]
  [<e1c661e5>] ? tg3_poll_work+0x2b/0x10b [tg3]
  [<e09df1d2>] ? ssb_write32+0x11/0x14 [b44]
  [<e1c662f9>] ? tg3_poll+0x34/0x9a [tg3]
  [<c0674058>] ? net_rx_action+0x7e/0x11c
  [<c04409c9>] ? __do_softirq+0x85/0x10c
  [<c0440944>] ? __do_softirq+0x0/0x10c
<IRQ>
  [<c04404ef>] ? _local_bh_enable_ip+0x68/0x87
  [<c044051b>] ? local_bh_enable_ip+0xd/0xf
  [<c046593b>] ? __raw_spin_unlock_bh+0x1c/0x1e
  [<c06fa4f2>] ? _raw_spin_unlock_bh+0xd/0xf
  [<e1c6281f>] ? spin_unlock_bh+0xd/0xf [tg3]
  [<e1c62cbe>] ? tg3_full_unlock+0x10/0x12 [tg3]
  [<e1c664c7>] ? tg3_reset_task+0xd7/0xe3 [tg3]
  [<c044ec37>] ? process_one_work+0x10b/0x1bc
  [<e1c663f0>] ? tg3_reset_task+0x0/0xe3 [tg3]
  [<c044fd41>] ? worker_thread+0x77/0xf9
  [<c0453048>] ? kthread+0x60/0x65
  [<c044fcca>] ? worker_thread+0x0/0xf9
  [<c0452fe8>] ? kthread+0x0/0x65
  [<c040337e>] ? kernel_thread_helper+0x6/0x10
Code: f0 e8 88 ff ff ff 8d 65 f8 5b 5e 5d c3 55 89 e5 56 53 0f 1f 44 00 
00 f6 8
EIP: [<e1c62f19>] tg3_tx_recover+0x1e/0x53 [tg3] SS:ESP 0068:c1801f30
---[ end trace 82381e9b93e397ad ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 20303, comm: kworker/0:2 Tainted: G      D     2.6.36-2.el5.elrepo #1
Call Trace:
  [<c043b3cd>] panic+0x62/0x15d
  [<c06fb7d1>] oops_end+0x99/0xa8
  [<e1c62f19>] ? tg3_tx_recover+0x1e/0x53 [tg3]
  [<c0405a62>] die+0x58/0x5e

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



