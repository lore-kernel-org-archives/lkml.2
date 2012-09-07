Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab2IGOly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:41:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51509 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2IGOlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:41:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 7 Sep 2012 16:41:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-kernel@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org,
        Apostolos Bartziokas <barz621@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Intel DZ77BH-55K, iTE IT8892 interrupt misrouting (was Re: [Bug
 47191] New: Firewire related BUG in kernels 3.3.7 and up on Intel HW.)
Message-ID: <20120907164142.2031e8da@stein>
In-Reply-To: <bug-47191-4803@https.bugzilla.kernel.org/>
References: <bug-47191-4803@https.bugzilla.kernel.org/>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please use reply-to-all in responses.)

On Sep 07 bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=47191
> 
>            Summary: Firewire related BUG in kernels 3.3.7 and up on Intel
>                     HW.
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 3.3.7+
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: IEEE1394
>         AssignedTo: drivers_ieee1394@kernel-bugs.osdl.org

As implied in thread "Firewire related problems with 3.3.7+ kernels." on
linux1394-user (http://marc.info/?t=134651740400005), this is not an
IEEE1394 driver bug.

Can the kernel do anything about that at all?

>         ReportedBy: barz621@gmail.com
>         Regression: No
> 
> 
> Created an attachment (id=79431)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=79431)
> lspci -vvv Output

The 1394 OHCI is located behind this bridge:
03:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 30)


> Since i installed linux on an Intel DZ77BH-55K i get the below message in my
> logs on every boot. (It might also be a problem with earlier kernels but 3.3.7
> was the first i installed on this machine.)
> 
> [    3.021058] irq 16: nobody cared (try booting with the "irqpoll" option)
> [    3.021111] Pid: 0, comm: swapper/0 Not tainted 3.5.3-1-ARCH #1
> [    3.021112] Call Trace:
> [    3.021113]  <IRQ>  [<ffffffff810d4d3d>] __report_bad_irq+0x3d/0xe0
> [    3.021118]  [<ffffffff810d5033>] note_interrupt+0x1a3/0x1f0
> [    3.021120]  [<ffffffff810d292f>] handle_irq_event_percpu+0xbf/0x260
> [    3.021122]  [<ffffffff810d2b18>] handle_irq_event+0x48/0x70
> [    3.021123]  [<ffffffff810d5b4a>] handle_fasteoi_irq+0x5a/0x100
> [    3.021125]  [<ffffffff810160c2>] handle_irq+0x22/0x40
> [    3.021128]  [<ffffffff81484cea>] do_IRQ+0x5a/0xe0
> [    3.021129]  [<ffffffff8147c12a>] common_interrupt+0x6a/0x6a
> [    3.021130]  <EOI>  [<ffffffffa02b3f01>] ? acpi_idle_enter_c1+0xda/0x104 [processor]
> [    3.021142]  [<ffffffffa02b3edc>] ? acpi_idle_enter_c1+0xb5/0x104 [processor]
> [    3.021145]  [<ffffffff8134f159>] cpuidle_enter+0x19/0x20
> [    3.021147]  [<ffffffff8134f7a6>] cpuidle_idle_call+0xa6/0x330
> [    3.021148]  [<ffffffff8101daaf>] cpu_idle+0xbf/0x130
> [    3.021151]  [<ffffffff81456fbc>] rest_init+0x80/0x84
> [    3.021153]  [<ffffffff818bbc35>] start_kernel+0x3c1/0x3ce
> [    3.021154]  [<ffffffff818bb673>] ? repair_env_string+0x5e/0x5e
> [    3.021156]  [<ffffffff818bb356>] x86_64_start_reservations+0x131/0x135
> [    3.021157]  [<ffffffff818bb45a>] x86_64_start_kernel+0x100/0x10f
> [    3.021158] handlers:
> [    3.021168] [<ffffffffa01eb0b0>] usb_hcd_irq [usbcore]
> [    3.021185] Disabling IRQ #16
> 
> When i disable Firewire from the BIOS the message goes away. After a question
> in the ieee1394 users mailing list the problem was specified to be a misrouted
> interrupt. Upgrading the BIOS caused problems with UEFI (i downgraded but
> doesn't matter for this) but you could still see the message when booting.
> 
> kernel drivers:
> 
> firewire_ohci          31653  0
> firewire_core          52733  1 firewire_ohci
> crc_itu_t               1363  1 firewire_core
> 
> Attached you will find lspci -vvv 
> 
> /proc/interupts :
> 
>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5      CPU6       CPU7       
>   0:         51          0          0          0          0          0         0          0  IR-IO-APIC-edge      timer
>   1:          3          0          0          0          0          0         0          0  IR-IO-APIC-edge      i8042
>   8:         66          0          0          0          0          0         0          0  IR-IO-APIC-edge      rtc0
>   9:          0          0          0          0          0          0         0          0  IR-IO-APIC-fasteoi   acpi
>  12:          4          0          0          0          0          0         0          0  IR-IO-APIC-edge      i8042
>  16:     100001          0          0          0          0          0         0          0  IR-IO-APIC-fasteoi   ehci_hcd:usb5
>  18:          0          0          0          0          0          0         0          0  IR-IO-APIC-fasteoi   firewire_ohci
>  23:         45          0          0          0          0          0         0          0  IR-IO-APIC-fasteoi   ehci_hcd:usb6
>  40:          0          0          0          0          0          0         0          0  DMAR_MSI-edge      dmar0
>  42:    1473002          0          0          0          0          0         0          0  IR-PCI-MSI-edge      radeon
>  43:      67067          0          0          0          0          0         0          0  IR-PCI-MSI-edge      ahci
>  44:          0          0          0          0          0          0         0          0  IR-PCI-MSI-edge      ahci
>  45:       6584          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  46:     364368          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  47:          0          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  48:          0          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  49:          0          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  50:          0          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  51:          0          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  52:          0          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  53:          0          0          0          0          0          0         0          0  IR-PCI-MSI-edge      xhci_hcd
>  54:         15          0          0          0          0          0         0          0  IR-PCI-MSI-edge      mei
>  55:     823643          0          0          0          0          0         0          0  IR-PCI-MSI-edge      eth0
>  56:        598          0          0          0          0          0         0          0  IR-PCI-MSI-edge      snd_hda_intel
>  57:        245          0          0          0          0          0         0          0  IR-PCI-MSI-edge      snd_hda_intel
> NMI:        830        954        687        816         38         50        42         54   Non-maskable interrupts
> LOC:     981830     617630     700773     594284     135468     138509    276879     148838   Local timer interrupts
> SPU:          0          0          0          0          0          0         0          0   Spurious interrupts
> PMI:        830        954        687        816         38         50        42         54   Performance monitoring interrupts
> IWI:          0          0          0          0          0          0         0          0   IRQ work interrupts
> RTR:          0          0          0          0          0          0         0          0   APIC ICR read retries
> RES:     536900     183838      26144       4632        399        291      6187        265   Rescheduling interrupts
> CAL:      10532      39027      41167      41149      40550      42333     42284      39389   Function call interrupts
> TLB:     104550     110486     103530      94268      12725      14161     12829      16951   TLB shootdowns
> TRM:          0          0          0          0          0          0         0          0   Thermal event interrupts
> THR:          0          0          0          0          0          0         0          0   Threshold APIC interrupts
> MCE:          0          0          0          0          0          0         0          0   Machine check exceptions
> MCP:         87         87         87         87         87         87        87         87   Machine check polls
> ERR:          0
> 

-- 
Stefan Richter
-=====-===-- =--= --===
http://arcgraph.de/sr/
