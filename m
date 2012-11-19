Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2KSQrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:47:31 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:49838 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2KSQra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:47:30 -0500
Message-ID: <50AA628A.1090405@xs4all.nl>
Date: Mon, 19 Nov 2012 17:47:06 +0100
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
>> How to proceed next?
> 
> Firstly, what does /proc/interrupts say?

# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:         39          0          0          0   IO-APIC-edge      timer
  1:        716        721        730        687   IO-APIC-edge      i8042
  4:       1631       1603       1713       1914   IO-APIC-edge      serial
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 16:        427        437        443        447   IO-APIC-fasteoi
snd_hda_intel
 17:          0          0          3          1   IO-APIC-fasteoi
ehci_hcd:usb4, ehci_hcd:usb5
 18:     100443     100710     103881     116011   IO-APIC-fasteoi
ohci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 20:       8049       8235       8456       9657   IO-APIC-fasteoi   serial
 40:          0          0          0          0   PCI-MSI-edge      AMD-Vi
 43:      47534      47847      49501      52187   PCI-MSI-edge      ahci
 44:     118811     119571     123111     134412   PCI-MSI-edge      eth0
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
 56:         33         28         36         28   PCI-MSI-edge
snd_hda_intel
 57:      52846      53825      56666      64450   PCI-MSI-edge      radeon
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     381988     405614     348070     323872   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:    1166893    1184781    1089048    1016935   Rescheduling interrupts
CAL:      34472      32009      62610      50241   Function call interrupts
TLB:          0          0          0          0   TLB shootdowns
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          8          8          8          8   Machine check polls
ERR:          4
MIS:          0

> Secondly, try building a kernel with the patch below and 
> CONFIG_USB_DEBUG enabled.  Let's see what the dmesg log says when the 
> problem occurs.

Will do!

Udo

