Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab2CKTgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 15:36:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59861 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2CKTgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 15:36:19 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Soeren Sonnenburg <sonne@debian.org>
Subject: Re: 3.3.0-rc5+git: WARNING: at drivers/gpu/drm/i915/i915_irq.c:652 ironlake_irq_handler+0x4ea/0x500()
Date: Sun, 11 Mar 2012 20:36:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <1330991976.9223.16.camel@no>
In-Reply-To: <1330991976.9223.16.camel@no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203112036.11205.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 6 marca 2012 o 00:59:36 Soeren Sonnenburg wrote:
> Hi,
> 
> I am getting this on a i7 system on a DH67BL intel board on current git
> and wonder whether I should be worried:
> 
> ------------[ cut here ]------------
> WARNING: at drivers/gpu/drm/i915/i915_irq.c:652
> ironlake_irq_handler+0x4ea/0x500() Hardware name:
> Missed a PM interrupt
> Modules linked in:
> Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc5+ #27
> Call Trace:
>  <IRQ>  [<ffffffff810939db>] ? warn_slowpath_common+0x7b/0xc0
>  [<ffffffff81093ad5>] ? warn_slowpath_fmt+0x45/0x50
>  [<ffffffff810ab2c6>] ? queue_work_on+0x16/0x20
>  [<ffffffff81492afa>] ? ironlake_irq_handler+0x4ea/0x500
>  [<ffffffff810ecfea>] ? handle_irq_event_percpu+0x3a/0x140
>  [<ffffffff81099c83>] ? __do_softirq+0xb3/0x130
>  [<ffffffff810ed131>] ? handle_irq_event+0x41/0x70
>  [<ffffffff810f048d>] ? handle_edge_irq+0x6d/0x120
>  [<ffffffff81041ae5>] ? handle_irq+0x15/0x20
>  [<ffffffff81041253>] ? do_IRQ+0x53/0xd0
>  [<ffffffff816cc12e>] ? common_interrupt+0x6e/0x6e
>  <EOI>  [<ffffffff816cbb1b>] ? _raw_spin_unlock_irqrestore+0x1b/0x40
>  [<ffffffff813e8737>] ? intel_idle+0xd7/0x150
>  [<ffffffff813e871a>] ? intel_idle+0xba/0x150
>  [<ffffffff815d6873>] ? cpuidle_idle_call+0x93/0xe0
>  [<ffffffff8103f1e9>] ? cpu_idle+0x79/0xe0
>  [<ffffffff81984c12>] ? start_kernel+0x366/0x371
>  [<ffffffff8198444c>] ? x86_64_start_kernel+0x104/0x113
> ---[ end trace 8b3760a8c69d9501 ]---
> 
> $ cat /proc/interrupts
> 
>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5     
>  CPU6       CPU7 0:       1801          0          0          0          0
>          0          0          0   IO-APIC-edge      timer 1:          3  
>        0          0          0          0          0          0          0
>   IO-APIC-edge      i8042 8:          1          0          0          0  
>        0          0          0          0   IO-APIC-edge      rtc0 9:     
>     0          0          0          0          0          0          0   
>       0   IO-APIC-fasteoi   acpi 12:          3          0          0     
>     0          0          0          0          0   IO-APIC-edge     
> i8042 16:        215          0          0          0          0         
> 0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1 23:  829615563  
>        0          0          0          0          0          0          0
>   IO-APIC-fasteoi   ehci_hcd:usb2 40:          0          0          0    
>      0          0          0          0          0   PCI-MSI-edge     
> PCIe PME 41:          0          0          0          0          0       
>   0          0          0   PCI-MSI-edge      PCIe PME 42:    4300572     
>     0          0          0          0          0          0          0  
> PCI-MSI-edge      i915 43:   51614938          0          0          0    
>      0          0          0          0   PCI-MSI-edge      ahci 44:  
> 35008209          0          0          0          0          0          0
>          0   PCI-MSI-edge      eth0 NMI:          0          0          0 
>         0          0          0          0          0   Non-maskable
> interrupts LOC:  419860182   17318718   22409016   16940072    3696355   
> 2776406    5544045    5374801   Local timer interrupts SPU:          0    
>      0          0          0          0          0          0          0  
> Spurious interrupts PMI:          0          0          0          0      
>    0          0          0          0   Performance monitoring interrupts
> IWI:          0          0          0          0          0          0    
>      0          0   IRQ work interrupts RTR:          6          0        
>  0          0          0          0          0          0   APIC ICR read
> retries RES:   15246280    9404003     289674      34811      10270      
> 4717       4437       3644   Rescheduling interrupts CAL:        633      
>  483        481        460        233        236        228        225  
> Function call interrupts TLB:     382928     369632     370463     359784 
>    381885     378229     393943     383276   TLB shootdowns TRM:         
> 0          0          0          0          0          0          0       
>   0   Thermal event interrupts THR:          0          0          0      
>    0          0          0          0          0   Threshold APIC
> interrupts MCE:          0          0          0          0          0    
>      0          0          0   Machine check exceptions MCP:       1677   
>    1677       1677       1677       1677       1677       1677       1677 
>  Machine check polls ERR:          0
> MIS:          0
> 
> $ lspci
> 
> 00:00.0 Host bridge: Intel Corporation Sandy Bridge DRAM Controller (rev
> 09) 00:02.0 VGA compatible controller: Intel Corporation Sandy Bridge
> Integrated Graphics Controller (rev 09) 00:16.0 Communication controller:
> Intel Corporation Cougar Point HECI Controller #1 (rev 04) 00:19.0
> Ethernet controller: Intel Corporation 82579V Gigabit Network Connection
> (rev 05) 00:1a.0 USB Controller: Intel Corporation Cougar Point USB
> Enhanced Host Controller #2 (rev 05) 00:1b.0 Audio device: Intel
> Corporation Cougar Point High Definition Audio Controller (rev 05) 00:1c.0
> PCI bridge: Intel Corporation Cougar Point PCI Express Root Port 1 (rev
> b5) 00:1c.3 PCI bridge: Intel Corporation Cougar Point PCI Express Root
> Port 4 (rev b5) 00:1d.0 USB Controller: Intel Corporation Cougar Point USB
> Enhanced Host Controller #1 (rev 05) 00:1f.0 ISA bridge: Intel Corporation
> Cougar Point LPC Controller (rev 05) 00:1f.2 SATA controller: Intel
> Corporation Cougar Point 6 port SATA AHCI Controller (rev 05) 00:1f.3
> SMBus: Intel Corporation Cougar Point SMBus Controller (rev 05) 01:00.0
> PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 10)
> 03:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller
> (rev 04)

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42907
for your bug/regression report, please add your address to the CC list in 
there, thanks!


-- 
Maciej Rutecki
http://www.mrutecki.pl
