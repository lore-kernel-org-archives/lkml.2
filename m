Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0D0T0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:26:15 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:61237 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0D0T0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=TUZWP6VRKOcE5+uTZ3c+LUxs4Au6eC3qQCyt3wL17sqZkpRojszZKCs9J27Sk7vhft
         fIUBe9o1Ku5FpFumO4K79ihvtmEgKJKo9HFzos86JBAjwN7j4MVUWyDym9AvqICF+sDK
         k76fhAam4YYVpIklAzYW1f8r2uGnYDNa/FjRU=
MIME-Version: 1.0
Date: Tue, 27 Apr 2010 12:26:12 -0700
Message-ID: <o2g466d8c5e1004271226rc9e60015u8e6cb998d6421e80@mail.gmail.com>
Subject: weired kernel oops
From: Yi Jin <yijin.ca@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

As a not-so-experienced kernel hacker, I have been puzzling this
weired oops for a while.
Basically, I have two questions cannot be answered by myself.
Hopefully,  you guys
can help. Thanks.


Below is the decoded oops and the kernel is a largely modified version of
2.4.25.   It shows that the causing instruction is in batch_entropy_store() and
the back trace seems pretty legitimate. So I also disassembled
 batch_entropy_store().

-----------------------------------------------------------------------------------------------------------------------------------
Unable to handle kernel paging request at virtual address
c019543e
*pde = 00000000
Oops: 0002
CPU:    0
EIP:    0010:[<c019543e>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010206
eax: f7e2c000   ebx: 00000000   ecx: 00000070   edx: d7402526
esi: d7402526   edi: 00005e4a   ebp: 0000000a   esp: c035dcf0
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=c035d000)
       f88b6000 f88b6060 ftk
Stack: c019565a 00005e4a d7402526 0000000a 00000000 14000001 c035dd5c c0195701
       f77344c0 0000010a c010a5ad 0000000a f7cb3000 c035dd5c c0372a40 0000000a
       c29dfbc0 00000140 c010a759 0000000a c035dd5c c29dfbc0 000f3f9c c03958a0
Call Trace:    [<c019565a>] [<c0195701>] [<c010a5ad>] [<c010a759>] [<c010cc08>]
  [<c019770a>] [<c019d0a1>] [<c011818e>] [<c01182aa>] [<c0118584>] [<c011850a>]
  [<c02524f0>] [<f88ffdc0>] [<c01141e0>] [<c0114626>] [<c02524f0>] [<c02524f0>]
  [<c024ab90>] [<c02524f0>] [<f8955598>] [<c02523a2>] [<c02524f0>] [<c0242cbf>]
  [<c0242d70>] [<c01141e0>] [<c0108e80>] [<c019543e>] [<c019565a>] [<c0195701>]
  [<c010a5ad>] [<c010a759>] [<c01070c0>] [<c010cc08>] [<c01070c0>] [<c01070e3>]
  [<c0107172>] [<c0105000>]
Code: 89 54 c8 04 8b 0d 84 4c 39 c0 a1 7c 4c 39 c0 8b 54 24 0c 89

>>EIP; c019543e <batch_entropy_store+2e/a0>   <=====
Trace; c019565a <add_timer_randomness+da/100>
Trace; c0195701 <add_interrupt_randomness+31/40>
Trace; c010a5ad <handle_IRQ_event+6d/70>
Trace; c010a759 <do_IRQ+69/b0>
Trace; c010cc08 <call_do_IRQ+5/d>
Trace; c019770a <serial_in+1a/40>
Trace; c019d0a1 <serial_console_write+71/220>
Trace; c011818e <__call_console_drivers+4e/70>
Trace; c01182aa <call_console_drivers+5a/120>
Trace; c0118584 <release_console_sem+24/90>
Trace; c011850a <printk+12a/140>
Trace; c02524f0 <ip_rcv_finish+0/2a0>
Trace; f88ffdc0 <END_OF_CODE+3856121c/????>
Trace; c01141e0 <do_page_fault+0/515>
Trace; c0114626 <do_page_fault+446/515>
Trace; c02524f0 <ip_rcv_finish+0/2a0>
Trace; c02524f0 <ip_rcv_finish+0/2a0>
Trace; c024ab90 <nf_hook_slow+60/c6>
Trace; c02524f0 <ip_rcv_finish+0/2a0>
Trace; f8955598 <END_OF_CODE+385b69f4/????>
Trace; c02523a2 <vf_ipv4_input+1b2/300>
Trace; c02524f0 <ip_rcv_finish+0/2a0>
Trace; c0242cbf <netif_proto_receive_skb+16f/180>
Trace; c0242d70 <netif_receive_skb+80/e0>
Trace; c01141e0 <do_page_fault+0/515>
Trace; c0108e80 <error_code+34/3c>
Trace; c019543e <batch_entropy_store+2e/a0>
Trace; c019565a <add_timer_randomness+da/100>
Trace; c0195701 <add_interrupt_randomness+31/40>
Trace; c010a5ad <handle_IRQ_event+6d/70>
Trace; c010a759 <do_IRQ+69/b0>
Trace; c01070c0 <default_idle+0/40>
Trace; c010cc08 <call_do_IRQ+5/d>
Trace; c01070c0 <default_idle+0/40>
Trace; c01070e3 <default_idle+23/40>
Trace; c0107172 <cpu_idle+52/70>
Trace; c0105000 <_stext+0/0>
Code;  c019543e <batch_entropy_store+2e/a0>
00000000 <_EIP>:
Code;  c019543e <batch_entropy_store+2e/a0>   <=====
   0:   89 54 c8 04               mov    %edx,0x4(%eax,%ecx,8)   <=====
Code;  c0195442 <batch_entropy_store+32/a0>
   4:   8b 0d 84 4c 39 c0         mov    0xc0394c84,%ecx
Code;  c0195448 <batch_entropy_store+38/a0>
   a:   a1 7c 4c 39 c0            mov    0xc0394c7c,%eax
Code;  c019544d <batch_entropy_store+3d/a0>
   f:   8b 54 24 0c               mov    0xc(%esp),%edx
Code;  c0195451 <batch_entropy_store+41/a0>
  13:   89 00                     mov    %eax,(%eax)

 <0>Kernel panic: Aiee, killing interrupt handler!

1 error issued.  Results may not be reliable.

------------------------------------------------------------------------------------------------------------------------------------------------

(gdb) disassemble batch_entropy_store
Dump of assembler code for function batch_entropy_store:
0xc0195410 <batch_entropy_store+0>:     mov    0xc0394c80,%eax
0xc0195415 <batch_entropy_store+5>:     test   %eax,%eax
0xc0195417 <batch_entropy_store+7>:     je     0xc01954a8
<batch_entropy_store+152>
0xc019541d <batch_entropy_store+13>:    mov    0x4(%esp),%edx
0xc0195421 <batch_entropy_store+17>:    mov    0xc0394c84,%ecx
0xc0195427 <batch_entropy_store+23>:    mov    0xc0394c78,%eax
0xc019542c <batch_entropy_store+28>:    mov    %edx,(%eax,%ecx,8)
<--------------------------------------------   why it did not crash
here???
0xc019542f <batch_entropy_store+31>:    mov    0x8(%esp),%edx
0xc0195433 <batch_entropy_store+35>:    mov    0xc0394c84,%ecx
0xc0195439 <batch_entropy_store+41>:    mov    0xc0394c78,%eax
0xc019543e <batch_entropy_store+46>:    mov    %edx,0x4(%eax,%ecx,8)
 <--------------------------------------------   crashing point
0xc0195442 <batch_entropy_store+50>:    mov    0xc0394c84,%ecx
0xc0195448 <batch_entropy_store+56>:    mov    0xc0394c7c,%eax
0xc019544d <batch_entropy_store+61>:    mov    0xc(%esp),%edx
0xc0195451 <batch_entropy_store+65>:    mov    %edx,(%eax,%ecx,4)
0xc0195454 <batch_entropy_store+68>:    mov    0xc0394c84,%ecx
0xc019545a <batch_entropy_store+74>:    mov    0xc0394c80,%eax
0xc019545f <batch_entropy_store+79>:    inc    %ecx
0xc0195460 <batch_entropy_store+80>:    dec    %eax
0xc0195461 <batch_entropy_store+81>:    and    %eax,%ecx
0xc0195463 <batch_entropy_store+83>:    cmp    0xc0394c88,%ecx
0xc0195469 <batch_entropy_store+89>:    je     0xc01954a8
<batch_entropy_store+152>
0xc019546b <batch_entropy_store+91>:    btsl   $0x0,0xc0394c94
0xc0195473 <batch_entropy_store+99>:    sbb    %eax,%eax
0xc0195475 <batch_entropy_store+101>:   test   %eax,%eax
0xc0195477 <batch_entropy_store+103>:   jne    0xc01954a2
<batch_entropy_store+146>
0xc0195479 <batch_entropy_store+105>:   pushf
0xc019547a <batch_entropy_store+106>:   pop    %edx
0xc019547b <batch_entropy_store+107>:   cli
0xc019547c <batch_entropy_store+108>:   movl   $0xc0318010,0xc0394c8c
0xc0195486 <batch_entropy_store+118>:   mov    0xc0318014,%eax
0xc019548b <batch_entropy_store+123>:   movl   $0xc0394c8c,0xc0318014
0xc0195495 <batch_entropy_store+133>:   mov    %eax,0xc0394c90
0xc019549a <batch_entropy_store+138>:   movl   $0xc0394c8c,(%eax)
0xc01954a0 <batch_entropy_store+144>:   push   %edx
0xc01954a1 <batch_entropy_store+145>:   popf
0xc01954a2 <batch_entropy_store+146>:   mov    %ecx,0xc0394c84
0xc01954a8 <batch_entropy_store+152>:   ret
End of assembler dump.

----------------------------------------------------------------------------------------------------------------------------------------


My questions are:
1.  why  %eax + %eac * 0x8 + 0x4   (as shown in the oops) is not equal
to  0x7f4bdcf8  ?
2.   why it didn't crash at instruction 0xc019542c, as it access a
memory location which is only 4 bytes lower?


Regarding the 1st  question, I understand that do_page_fault()
retrieves values of registers from
the stack and it might enable local interrupts before dumping the
registers. Could this mean
that the stack has been corrupted by some interrupts service handlers?


Look forward to hearing from you. Any comments will be appreciated.

Cheers,
Yi
