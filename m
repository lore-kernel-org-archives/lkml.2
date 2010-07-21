Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab0GURxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:53:38 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:54428 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0GURxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:53:34 -0400
X-Greylist: delayed 1045 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jul 2010 13:53:33 EDT
Message-ID: <4C472FDC.6020505@onera.fr>
Date: Wed, 21 Jul 2010 19:35:24 +0200
From: Paul Chavent <Paul.Chavent@onera.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Soft lockup debug for arm (at91sam9g20)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Wed, 21 Jul 2010 19:36:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I try to run a linux with the preempt rt patch on my board (an 
at91sam9g20 based board).

I have an error message, but i need help to understand where i should 
search.

Here is the message :

Freeing init memory: 108K 
 

BUG: soft lockup - CPU#0 stuck for 61s! [rcS:165] 
 

irq event stamp: 0 
 

hardirqs last  enabled at (0): [<(null)>] (null) 
 

hardirqs last disabled at (0): [<c00323c0>] copy_process+0x248/0xe38 
 

softirqs last  enabled at (0): [<c00323c0>] copy_process+0x248/0xe38
softirqs last disabled at (0): [<(null)>] (null)

Pid: 165, comm:                  rcS
CPU: 0    Tainted: G        W   (2.6.33.6-rt26 #2)
PC is at uart_start+0x68/0x74
LR is at uart_start+0x68/0x74
pc : [<c014d924>]    lr : [<c014d924>]    psr: 60000013
sp : c3c7fe40  ip : c3c7fe40  fp : c3c7fe54
r10: c3c53800  r9 : c079364c  r8 : 0000000d
r7 : c3c5280d  r6 : 00000000  r5 : c079364c  r4 : c3c53800
r3 : fefff200  r2 : 00000002  r1 : 0000000d  r0 : c079364c
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 23ca4000  DAC: 00000015
[<c0024fd8>] (show_regs+0x0/0x50) from [<c00647a8>] 
(softlockup_tick+0x11c/0x198)
  r5:c078f2a8 r4:c3c7fdf8
[<c006468c>] (softlockup_tick+0x0/0x198) from [<c003f860>] 
(run_local_timers+0x1c/0x20)
[<c003f844>] (run_local_timers+0x0/0x20) from [<c003f8a0>] 
(update_process_times+0x3c/0x54)
[<c003f864>] (update_process_times+0x0/0x54) from [<c0056d00>] 
(tick_periodic+0x38/0xd8)
  r7:c026d2c8 r6:c026d228 r5:00000046 r4:33db2580
[<c0056cc8>] (tick_periodic+0x0/0xd8) from [<c0056dc0>] 
(tick_handle_periodic+0x20/0x10c)
  r7:c026d2c8 r6:c026d228 r5:c0289bfc r4:00000001
[<c0056da0>] (tick_handle_periodic+0x0/0x10c) from [<c002c528>] 
(at91sam926x_pit_interrupt+0x5c/0x74)
[<c002c4cc>] (at91sam926x_pit_interrupt+0x0/0x74) from [<c0064fc8>] 
(handle_irq_action+0x70/0x78)
  r7:c026d2c8 r6:00000001 r5:c0270fd4 r4:c026d2c8
[<c0064f58>] (handle_irq_action+0x0/0x78) from [<c0065008>] 
(handle_IRQ_event+0x38/0xf0)
  r7:c026d2c8 r6:00000001 r5:00000000 r4:c026d2c8
[<c0064fd0>] (handle_IRQ_event+0x0/0xf0) from [<c0067224>] 
(handle_level_irq+0x9c/0x13c)
  r7:c026d2c8 r6:00000001 r5:c0271010 r4:c0270fd4
[<c0067188>] (handle_level_irq+0x0/0x13c) from [<c0023044>] 
(asm_do_IRQ+0x44/0xa0)
  r7:00000001 r6:00000000 r5:00000001 r4:c02806c4
[<c0023000>] (asm_do_IRQ+0x0/0xa0) from [<c0023b74>] (__irq_svc+0x54/0xa0)
Exception stack(0xc3c7fdf8 to 0xc3c7fe40)
fde0:                                                       c079364c 
0000000d
fe00: 00000002 fefff200 c3c53800 c079364c 00000000 c3c5280d 0000000d 
c079364c
fe20: c3c53800 c3c7fe54 c3c7fe40 c3c7fe40 c014d924 c014d924 60000013 
ffffffff
  r7:00000001 r6:00000001 r5:fefff000 r4:ffffffff
[<c014d8bc>] (uart_start+0x0/0x74) from [<c014fcac>] (uart_write+0xbc/0xe0)
  r5:c3892000 r4:00000000
[<c014fbf0>] (uart_write+0x0/0xe0) from [<c0147df0>] 
(n_tty_write+0x1d0/0x468)
[<c0147c20>] (n_tty_write+0x0/0x468) from [<c014519c>] 
(tty_write+0x154/0x264)
[<c0145048>] (tty_write+0x0/0x264) from [<c0145354>] 
(redirected_tty_write+0xa8/0xbc)
[<c01452ac>] (redirected_tty_write+0x0/0xbc) from [<c00939a4>] 
(vfs_write+0xac/0xe0)
  r9:00000000 r8:00000000 r7:00000004 r6:c3c7ff70 r5:4001e000
r4:c385c2e0
[<c00938f8>] (vfs_write+0x0/0xe0) from [<c0093aa8>] (sys_write+0x44/0x74)
  r7:00000004 r6:0000000e r5:4001e000 r4:c385c2e0
[<c0093a64>] (sys_write+0x0/0x74) from [<c0024000>] 
(ret_fast_syscall+0x0/0x34)
  r9:c3c7e000 r8:c00241a4 r6:0000000e r5:401cb5c0 r4:0000000e





Thank you for your help.

Paul.

