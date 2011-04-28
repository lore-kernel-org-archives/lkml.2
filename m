Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab1D1TmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:42:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35955 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1D1TmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Q1rwsd8wrpdLEhFCF/O3Yn0xLSJYotZBcc/wwP4kiqlxwE3aDBEfVuK6UOTKoVQlKy
         IpJzosj17OAb/S5qxo0Xh6ZTCbHxyzbHkH2Zmw/1s29lGKM002wBtick09tUKR0WE2AQ
         YXYjp56Y9uhEyR9U7TcCGMwRUaiy2Jv7/WJY4=
Message-ID: <4DB9C31B.9010905@gmail.com>
Date: Thu, 28 Apr 2011 21:42:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0a2) Gecko/20110420 Thunderbird/3.3a4pre
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: i915: irq nobody cared
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while watching flash video in a browser I got:
irq 42: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Tainted: G        W   2.6.39-rc3-mm1_64+ #1423
Call Trace:
  <IRQ>  [<ffffffff810bd671>] __report_bad_irq+0x31/0xc0
  [<ffffffff810bd934>] note_interrupt+0x194/0x1d0
  [<ffffffff810bbb58>] handle_irq_event_percpu+0xe8/0x160
  [<ffffffff810bbc05>] handle_irq_event+0x35/0x60
  [<ffffffff810be1af>] handle_edge_irq+0x6f/0x110
  [<ffffffff81033a4d>] handle_irq+0x1d/0x30
  [<ffffffff810336c8>] do_IRQ+0x58/0xe0
  [<ffffffff815f9753>] common_interrupt+0x13/0x13
  <EOI>  [<ffffffff81030850>] ? __switch_to+0x260/0x2c0
  [<ffffffff8109a46e>] ? tick_nohz_stop_sched_tick+0x28e/0x3d0
  [<ffffffff81039be4>] ? default_idle+0x24/0x40
  [<ffffffff81030236>] cpu_idle+0x36/0xb0
  [<ffffffff815e3108>] rest_init+0x68/0x70
  [<ffffffff81a7fb6a>] start_kernel+0x35c/0x367
  [<ffffffff81a7f322>] x86_64_start_reservations+0x132/0x136
  [<ffffffff81a7f417>] x86_64_start_kernel+0xf1/0xf8
handlers:
[<ffffffff8132ee60>] (i915_driver_irq_handler+0x0/0x420)
Disabling IRQ #42

Now the interrupt is polled, so that the graphics is obviously sluggish.

I have also /sys/kernel/debug/dri contents if you want anything of that. 
Going to reboot now.

# lspci -vvnnxxxs 00:02.0
00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31 
Express Integrated Graphics Controller [8086:29c2] (rev 02) (prog-if 00 
[VGA controller])
         Subsystem: Intel Corporation 82G33/G31 Express Integrated 
Graphics Controller [8086:29c2]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 42
         Region 0: Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
         Region 1: I/O ports at ec00 [size=8]
         Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
         Region 3: Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
         Expansion ROM at <unassigned> [disabled]
         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                 Address: fee0300c  Data: 4161
         Capabilities: [d0] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: i915
00: 86 80 c2 29 07 04 90 00 02 00 00 03 00 00 00 00
10: 00 00 b8 fe 01 ec 00 00 08 00 00 d0 00 00 a0 fe
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c2 29
30: 00 00 00 00 90 00 00 00 00 00 00 00 05 01 00 00
40: 09 00 0b 01 00 00 00 00 01 00 00 00 00 00 00 00
50: 00 00 30 02 c9 03 00 00 00 00 00 00 00 00 80 af
60: 00 00 02 02 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 05 d0 01 00 0c 30 e0 fe 61 41 00 00 00 00 00 00
a0: 11 11 00 00 00 00 06 03 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 01 02 00
e0: 00 00 00 00 00 00 00 00 00 80 00 00 00 00 00 00
f0: 10 00 00 00 00 00 00 00 90 0f 03 00 e4 e0 5b af

regards,
-- 
js
