Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0DSNXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:23:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47608 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0DSNXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=dn6eY57tPkUVd0aBrlyDY0mP3JOyIrP74nb/Pi2Xz6obJ5PC/qp7AmieXFY6rxtaWX
         vqznx7OmOioxFr4ZARWwGLHvEIW6EmEWFpBoSAEw3dXYtNuBtoRomS62lTFUQGSWwmW0
         UQx1Zgpq8MhcVCjdNSBpvhNyaXicH7g3fYigE=
MIME-Version: 1.0
In-Reply-To: <x2n448a67a1004190620z6b23d12vc4ba54f2d460d125@mail.gmail.com>
References: <j2n448a67a1004190442h2d01f517ld1cd0449c7a0513@mail.gmail.com>
	 <x2n448a67a1004190620z6b23d12vc4ba54f2d460d125@mail.gmail.com>
Date: Mon, 19 Apr 2010 18:53:37 +0530
Message-ID: <o2p9bde694e1004190623n24a4308le84451cc076d4a46@mail.gmail.com>
Subject: Kmemcheck issue
From: naveen yadav <yad.naveen@gmail.com>
To: linux-arm-kernel-request@lists.arm.linux.org.uk,
       linux newbie <linux.newbie79@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

      I  am  trying to   run  Kmemcheck on   a  Cortex ( ARM-v7)
board  running  Linux 2.6.30.9

At boot-up time,  as  soon  as  Timer-device is  enabled,   I  find
that   timer  gets  disabled  because  system
gets spurious  interrupts  on  that  irq  line.


PID hash table entries: 1024 (order: 10, 4096 bytes)
Linux System timer initialize
irq 23: nobody cared (try booting with the "irqpoll" option)
[<c002e148>] (unwind_backtrace+0x0/0xe8) from [<c002c4b8>]
(dump_stack+0x18/0x1c)
[<c002c4b8>] (dump_stack+0x18/0x1c) from [<c006ad74>]
(__report_bad_irq+0x80/0xb0)
[<c006ad74>] (__report_bad_irq+0x80/0xb0) from [<c006af28>]
(note_interrupt+0x184/0x1f0)
[<c006af28>] (note_interrupt+0x184/0x1f0) from [<c006ba38>]
(handle_edge_irq+0xe8/0x160)
[<c006ba38>] (handle_edge_irq+0xe8/0x160) from [<c0027060>]
(asm_do_IRQ+0x60/0x74)
[<c0027060>] (asm_do_IRQ+0x60/0x74) from [<c0027a30>] (__irq_svc+0x30/0x80)
Exception stack(0xc0373ec0 to 0xc0373f08)
3ec0: 00000017 c0372000 00000002 00000000 00000002 c038e8f4 00000000 0aa00000
3ee0: c0372000 c03bfc40 0000001f c0373f44 00000100 c0373f08 c0047ffc c0047c98
3f00: 20000153 ffffffff
[<c0027a30>] (__irq_svc+0x30/0x80) from [<c0047ffc>] (irq_exit+0x44/0x4c)
[<c0047ffc>] (irq_exit+0x44/0x4c) from [<c0047ffc>] (irq_exit+0x44/0x4c)
[<c0047ffc>] (irq_exit+0x44/0x4c) from [<c0027064>] (asm_do_IRQ+0x64/0x74)
[<c0027064>] (asm_do_IRQ+0x64/0x74) from [<c0027a30>] (__irq_svc+0x30/0x80)
Exception stack(0xc0373f78 to 0xc0373fc0)
3f60:                                                       00000000 c037c15c
3f80: 00000001 600001d3 955fffff c00242ec c0399f80 0aa00000 c0023000 412fc082
3fa0: 0000001f c0373ff4 c0373fc0 c0373fc0 c0008974 c0019798 20000153 ffffffff
[<c0027a30>] (__irq_svc+0x30/0x80) from [<c0008974>] (start_kernel+0x168/0x3e4)
[<c0008974>] (start_kernel+0x168/0x3e4) from [<60008034>] (0x60008034)
handlers:
[<c003a604>] (sdp_timer_interrupt+0x0/0x38)
Disabling IRQ #23
Console: colour dummy device 80x30
console [ttyS1] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)


Later,  when  calibrating delay  loop,  the system is hung  as timer
is not working.

The problem happens  even if  I  set kmemcheck_enabled = 0 at  boot.
( I also commented out     pagetable_init(&meminfo)  ).

 If  you have seen this before,  please let me know.

( I know that  your patch was written for   ARM v6.     My cpu is
Cortex .    I am aware that  I may have to make some change in the
 instruction simulation handling. )

Thanks
