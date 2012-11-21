Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2KUHmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:42:46 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:37328 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab2KUHmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:42:44 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 02:42:44 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqABAFCErFCWZd+d/2dsb2JhbAANN4YguGaDXYM7VjUCJgK0OnCTAIEijE2CFIETA6lC
Subject: BUG at kernel/timer.c:1100 when using JFFS2
From: Nathan Williams <nathan@traverse.com.au>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Nov 2012 18:37:37 +1100
Message-ID: <1353483457.9160.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've come across a problem when loading a module straight after unmounting a JFFS2 partition.
I'm using a Geos ADSL router board with an AMD Geode LX/CS5536 chipset and a Hynix H27U1G8F2BTR NAND flash.

I can reproduce my problem with this shell script:

#!/bin/sh
mount -t jffs2 mtd:logs /mnt
echo "Hello World" > /mnt/file
umount /mnt
modprobe r8169

After a few seconds I get this panic:

kernel BUG at kernel/timer.c:1100!
invalid opcode: 0000 [#1] 
Modules linked in: r8169 cs553x_nand [last unloaded: r8169]
Pid: 0, comm: swapper Not tainted 3.6.0 #1  
EIP: 0060:[<c10285ea>] EFLAGS: 00010082 CPU: 0
EIP is at cascade+0x11e/0x122
EAX: ce809f98 EBX: ce809f98 ECX: cea67938 EDX: 00000000
ESI: 00000000 EDI: cea67938 EBP: c138ea80 ESP: ce809f8c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7701d8a CR3: 0dd36000 CR4: 00000090                         
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000                         
DR6: ffff0ff0 DR7: 00000400                                                     
Process swapper (pid: 0, ti=ce808000 task=c13244c0 task.ti=c1318000)            
Stack:                                                                          
 ce809f98 0000001d 00000000 cea67938 cea67938 c138ea80 00000000 ce809fc8        
 00000100 c10287d0 00000246 c138f890 c138f690 c138f490 c138f290 ce809fc8        
 ce809fc8 00000004 00000001 00000001 00000100 c10241ef 0000000a 00200000        
Call Trace:                                                                     
 [<c10287d0>] ? run_timer_softirq+0x134/0x1ac                                   
 [<c10241ef>] ? __do_softirq+0x79/0x11c                                         
 [<c1024176>] ? irq_enter+0x4c/0x4c                                             
 <IRQ>                                                                          
 [<c102402c>] ? irq_exit+0x5b/0x69                                              
 [<c1003344>] ? do_IRQ+0x34/0x7d                                                
 [<c12661c9>] ? common_interrupt+0x29/0x30                                      
 [<c10078e9>] ? default_idle+0x21/0x2d                                          
 [<c1007b3f>] ? cpu_idle+0x52/0x54                                              
 [<c1344935>] ? start_kernel+0x236/0x286                                        
Code: c1 e8 1a 8d 94 c5 10 0e 00 00 e9 7c ff ff ff 8b 44 24 04 83 c4 14 5b 5e 5f
EIP: [<c10285ea>] cascade+0x11e/0x122 SS:ESP 0068:ce809f8c                      
---[ end trace 9942a8bf288b5a17 ]---                                            
Kernel panic - not syncing: Fatal exception in interrupt

Any ideas on what I should do next?

Regards,
Nathan

