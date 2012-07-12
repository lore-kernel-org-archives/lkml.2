Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198Ab2GLOyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:54:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34531 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934010Ab2GLOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:54:13 -0400
Date: Thu, 12 Jul 2012 10:54:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-usb@vger.kernel.org, Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.4: disabling irq
In-Reply-To: <4FFED900.1020606@xs4all.nl>
Message-ID: <Pine.LNX.4.44L0.1207121049590.1413-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, Udo van den Heuvel wrote:

> # cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:         40          0          0          0   IO-APIC-edge      timer
>   1:          1          4      91884        418   IO-APIC-edge      i8042
>   4:          1         25     607223       1584   IO-APIC-edge      serial
>   6:          0          0          8          0   IO-APIC-edge      floppy
>   7:          1          0          0          0   IO-APIC-edge
> parport0
>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  12:          3        106     980333       3914   IO-APIC-edge      i8042
>  14:          0          5     169732        457   IO-APIC-edge
> pata_atiixp
>  15:          0          0          0          0   IO-APIC-edge
> pata_atiixp
>  16:          0          0       3038         33   IO-APIC-fasteoi
> sata_sil24, ohci_hcd:usb1, ohci_hcd:usb2, snd_hda_intel
>  17:          0          4      24053        119   IO-APIC-fasteoi
> ehci_hcd:usb3
>  18:         25        190   18052161      21311   IO-APIC-fasteoi
> ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
>  19:          1          9     187895        487   IO-APIC-fasteoi
> ehci_hcd:usb4
>  20:          7        135    3756346       8907   IO-APIC-fasteoi   serial
>  22:        127        719   14673690      33318   IO-APIC-fasteoi   ahci
>  43:        115       1072   33699508      73116   PCI-MSI-edge      eth0
>  44:         27        252    3044666      11507   PCI-MSI-edge      radeon
>  45:          0          0         21          0   PCI-MSI-edge
> snd_hda_intel
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC:   15971203   15548951   13031603   13145359   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:          0          0          0          0   Performance
> monitoring interrupts
> IWI:          0          0          0          0   IRQ work interrupts
> RTR:          0          0          0          0   APIC ICR read retries
> RES:   57916374   44634814   19199377   43219640   Rescheduling interrupts
> CAL:       2241       2293       2327       2196   Function call interrupts
> TLB:     577983     648537     579293     635466   TLB shootdowns
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:        581        581        581        581   Machine check polls
> ERR:          0
> MIS:          0
> 
> 
> 
> So what can we conclude?

The conclusion is that ohci-hcd is the only driver using IRQ 18.  If 
you build a kernel with CONFIG_USB_DEBUG enabled, it will be possible 
to see if the OHCI hardware is responsible for the IRQ problem.

When the IRQ line gets disabled again, make a copy of the

	/sys/kernel/debug/usb/ohci/*/registers

files and post them, along with a copy of 
/sys/kernel/debug/usb/devices.

Alan Stern

