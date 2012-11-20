Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2KTOlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:41:51 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:42212 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KTOlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:41:49 -0500
Message-ID: <50AB96A0.80009@xs4all.nl>
Date: Tue, 20 Nov 2012 15:41:36 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Alan Stern <stern@rowland.harvard.edu>,
        Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <Pine.LNX.4.44L0.1211191139140.1598-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1211191139140.1598-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-19 17:41, Alan Stern wrote:
> Firstly, what does /proc/interrupts say?

# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:         40          0          0          0   IO-APIC-edge      timer
  1:        631        640        677        734   IO-APIC-edge      i8042
  4:       1026        976        961       1098   IO-APIC-edge      serial
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 16:        409        403        406        414   IO-APIC-fasteoi
snd_hda_intel
 17:          1          1          0          2   IO-APIC-fasteoi
ehci_hcd:usb4, ehci_hcd:usb5
 18:      62356      62649      64102      67369   IO-APIC-fasteoi
ohci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 20:       5774       5762       5902       6405   IO-APIC-fasteoi   serial
 40:          0          0          0          0   PCI-MSI-edge      AMD-Vi
 43:      19483      19239      19938      20909   PCI-MSI-edge      ahci
 44:      51837      52223      53122      55971   PCI-MSI-edge      eth0
 45:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 46:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 47:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 48:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 49:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 50:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 51:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 52:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 53:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 54:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 55:          0          0          0          0   PCI-MSI-edge
xhci_hcd
 56:         26         24         42         31   PCI-MSI-edge
snd_hda_intel
 57:      28748      28431      29792      32594   PCI-MSI-edge      radeon
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     271724     235396     273222     256476   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:     534762     574540     368898     508436   Rescheduling interrupts
CAL:      30439      42897      30212      31668   Function call interrupts
TLB:          0          0          0          0   TLB shootdowns
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          4          4          4          4   Machine check polls
ERR:          8
MIS:          0

> Secondly, try building a kernel with the patch below and 
> CONFIG_USB_DEBUG enabled.  Let's see what the dmesg log says when the 
> problem occurs.

I just booted into 3.6.7 with the patch:

# dmesg|sort|uniq
ohci_hcd 0000:00:12.0: IRQ: 24 8000005a
ohci_hcd 0000:00:14.5: IRQ: 24 8000005a
#

So what does this mean?
I did not get the `disabling irq` yet.


Udo
