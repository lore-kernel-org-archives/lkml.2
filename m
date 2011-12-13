Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1LMUhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:37:24 -0500
Received: from relay01.mx.bawue.net ([193.7.176.67]:49393 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab1LMUhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:37:22 -0500
Date: Tue, 13 Dec 2011 21:37:15 +0100
From: Nils Radtke <lkml@Think-Future.com>
To: Linux Kernel-List <linux-kernel@vger.kernel.org>
Subject: kernel BUG at mm/slab.c:501, invalid opcode: 0000 [#1] PREEMPT
Message-ID: <20111213203715.GA9193@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.com>
Mail-Followup-To: Nils Radtke <lkml@Think-Future.com>,
	Linux Kernel-List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bkp: p2mi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi, 

Just got this:

Ask for details.

Thanks.

Linux host 3.1.0+ #2 PREEMPT Mon Oct 31 19:56:17 CET 2011 i686 GNU/Linux

------------[ cut here ]------------
kernel BUG at mm/slab.c:501!
invalid opcode: 0000 [#1] PREEMPT
Modules linked in: ath5k ath pcmcia_rsrc firewire_ohci firewire_core [last unloaded: libphy]

Pid: 23464, comm: wget Not tainted 3.1.0+ #2 Acer            Extensa 5220                   /Columbia
EIP: 0060:[<c10e5386>] EFLAGS: 00010046 CPU: 0
EIP is at kfree+0xb6/0x1a0
EAX: f6b29900 EBX: dec1a980 ECX: 00000000 EDX: 00000000
ESI: dec1a980 EDI: cf9c8000 EBP: f2665dac ESP: f2665d94
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process wget (pid: 23464, ti=f2664000 task=efe10170 task.ti=f2664000)
Stack:
 c15f63d4 c15f3b22 00000286 dec1a980 dec1a980 000005a0 f2665dbc c15f3b22
 dec1a980 000005a0 f2665dc8 c15f3562 dec1a980 f2665e38 c16877c6 000005a0
 00000000 f2665e18 00000246 00000001 00000002 00000000 6af09045 efe10438
Call Trace:
 [<c15f63d4>] ? skb_copy_datagram_iovec+0x54/0x2e0
 [<c15f3b22>] ? skb_release_data+0xa2/0xb0
 [<c15f3b22>] skb_release_data+0xa2/0xb0
 [<c15f3562>] __kfree_skb+0x12/0x90
 [<c16877c6>] tcp_recvmsg+0x9c6/0xb20
 [<c15ee9bb>] ? sock_update_classid+0x5b/0x1c0
 [<c16a7263>] inet_recvmsg+0x43/0x60
 [<c15eb2e0>] sock_aio_read+0x130/0x140
 [<c12afabd>] ? blk_finish_plug+0xd/0x30
 [<c10ef514>] do_sync_read+0xa4/0xe0
 [<c10ef8b7>] ? rw_verify_area+0x67/0x120
 [<c10efe39>] vfs_read+0x149/0x160
 [<c10efe88>] sys_read+0x38/0x70
 [<c17b5b8c>] sysenter_do_call+0x12/0x32
 [<c17b0000>] ? dbgbuf+0x19c/0x1d0
Code: 0c 5b 5e 5f 5d c3 8d b4 26 00 00 00 00 ff 75 f0 9d e8 3f 10 f8 ff 83 c4 0c 5b 5e 5f 5d c3 89 f0 89 da e8 36 82 6c 00 8b 03 eb b8 <0f> 0b 8b 40 1c eb 90 8b 40 1c eb 84 89 e0 25 00 e0 ff ff 83 40
EIP: [<c10e5386>] kfree+0xb6/0x1a0 SS:ESP 0068:f2665d94
---[ end trace 756f840e7985dc87 ]---

-- 
   Because the wine remembers. 
