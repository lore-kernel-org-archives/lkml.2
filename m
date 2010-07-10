Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0GJAsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:48:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61648 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0GJAsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ns2yX0JOqQcjjrLMrbRIj8p7aT79+l9OS0LdsY61fplBOuD3LzeF1Q8zY9UCTFnAmx
         HGUJb0B7Tba4NVSkkREF5bCyr3BQqmrt+EohHP5Xi60BbjRiwzlD3c3RLgb/u+cl0U5O
         cLWEm2zYGpXG+wy+GVdgPDYzGl6q6LUCjhL/I=
Message-ID: <4C37C365.6090508@gmail.com>
Date: Fri, 09 Jul 2010 18:48:37 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: Bryan Hundven <bryanhundven@gmail.com>
CC: mchehab@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Interrupt Affinity in SMP
References: <AANLkTimhqRAMjaVNwo50GJO9B6kTzySWVtK04gEdu0rg@mail.gmail.com>
In-Reply-To: <AANLkTimhqRAMjaVNwo50GJO9B6kTzySWVtK04gEdu0rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 04:59 PM, Bryan Hundven wrote:
> Mauro, list,
>
> (please CC me in replies, I am not on the lkml list).
>
> I am having a similar issue as:
> http://lkml.indiana.edu/hypermail/linux/kernel/1006.3/01811.html
> which has no responses.
>
> My company is using an evaluation of dual 5645 xeon board with the 5520 chipset.
> Attached is my kernel config.
>
> We have 12 82580 intel (igb) nics, and their affinity is set to
> 0xffffffff, but I see all interrupts happening on cpu0:
> =====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====
> root@(none):~# cat /proc/irq/85/smp_affinity
> ffffff
> root@(none):~# cat /proc/irq/86/smp_affinity
> ffffff
> root@(none):~# cat /proc/irq/87/smp_affinity
> ffffff

Tried changing these files to exclude CPU0?

Have you tried running the irqbalance daemon? That's what you likely 
want to be doing anyway..

> =====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====
>
> =====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====
> root@(none):~# cat /proc/interrupts
>              CPU0       CPU1       CPU2       CPU3       CPU4
> CPU5       CPU6       CPU7       CPU8       CPU9       CPU10
> CPU11      CPU12      CPU13      CPU14      CPU15      CPU16
> CPU17      CPU18      CPU19      CPU20      CPU21      CPU22
> CPU23
>     0:         70          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-edge      timer
>     1:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-edge      i8042
>     4:       4282          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-edge      serial
>     8:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-edge      rtc0
>     9:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-fasteoi   acpi
>    12:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-edge      i8042
>    14:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-edge      ata_piix
>    15:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-edge      ata_piix
>    16:        438          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-fasteoi   pata_it8213
>    18:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-fasteoi   uhci_hcd:usb4
>    19:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-fasteoi   ata_piix, uhci_hcd:usb3
>    23:         26          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
>    64:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    65:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    66:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    67:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    68:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    69:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    70:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    71:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    72:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    73:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      aerdrv
>    76:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      ioat-msix
>    77:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      ioat-msix
>    78:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      ioat-msix
>    79:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      ioat-msix
>    80:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      ioat-msix
>    81:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      ioat-msix
>    82:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      ioat-msix
>    83:          3          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      ioat-msix
>    84:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      pkp_dev
>    85:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0
>    86:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0-TxRx-0
>    87:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0-TxRx-1
>    88:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0-TxRx-2
>    89:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0-TxRx-3
>    90:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0-TxRx-4
>    91:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0-TxRx-5
>    92:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0-TxRx-6
>    93:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth0-TxRx-7
>    94:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1
>    95:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1-TxRx-0
>    96:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1-TxRx-1
>    97:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1-TxRx-2
>    98:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1-TxRx-3
>    99:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1-TxRx-4
>   100:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1-TxRx-5
>   101:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1-TxRx-6
>   102:         47          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth1-TxRx-7
>   103:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2
>   104:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2-TxRx-0
>   105:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2-TxRx-1
>   106:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2-TxRx-2
>   107:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2-TxRx-3
>   108:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2-TxRx-4
>   109:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2-TxRx-5
>   110:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2-TxRx-6
>   111:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth2-TxRx-7
>   112:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3
>   113:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3-TxRx-0
>   114:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3-TxRx-1
>   115:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3-TxRx-2
>   116:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3-TxRx-3
>   117:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3-TxRx-4
>   118:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3-TxRx-5
>   119:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3-TxRx-6
>   120:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth3-TxRx-7
>   121:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4
>   122:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4-TxRx-0
>   123:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4-TxRx-1
>   124:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4-TxRx-2
>   125:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4-TxRx-3
>   126:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4-TxRx-4
>   127:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4-TxRx-5
>   128:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4-TxRx-6
>   129:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth4-TxRx-7
>   130:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5
>   131:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5-TxRx-0
>   132:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5-TxRx-1
>   133:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5-TxRx-2
>   134:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5-TxRx-3
>   135:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5-TxRx-4
>   136:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5-TxRx-5
>   137:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5-TxRx-6
>   138:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth5-TxRx-7
>   139:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6
>   140:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6-TxRx-0
>   141:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6-TxRx-1
>   142:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6-TxRx-2
>   143:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6-TxRx-3
>   144:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6-TxRx-4
>   145:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6-TxRx-5
>   146:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6-TxRx-6
>   147:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth6-TxRx-7
>   148:          1          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7
>   149:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7-TxRx-0
>   150:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7-TxRx-1
>   151:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7-TxRx-2
>   152:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7-TxRx-3
>   153:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7-TxRx-4
>   154:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7-TxRx-5
>   155:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7-TxRx-6
>   156:         46          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> PCI-MSI-edge      eth7-TxRx-7
>   NMI:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> Non-maskable interrupts
>   LOC:      45670      45920      45859      45793      45791
> 45755      45720      45685      45796      45615      45580
> 45545      45503      45474      45436      45405      45369
> 45334      45299      45264      45229      45194      45159
> 45106   Local timer interrupts
>   SPU:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0   Spurious
> interrupts
>   PMI:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> Performance monitoring interrupts
>   PND:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0
> Performance pending work
>   RES:        109          2          1          3          0
> 1          0          1          0          1          0          1
>        8          1         47          1          0          1
>   0          1          0          1          0          8
> Rescheduling interrupts
>   CAL:          5        316        132        130        128
> 126        124        122        120        118        116        114
>        112        110        108        106        104        102
>   100         98         96         94         92         86   Function
> call interrupts
>   TLB:         13          6          4          0          1
> 0          0          0          0          0          0          0
>       24          0         13         28          1          0
>   0          0          0          0          0          0   TLB
> shootdowns
>   TRM:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0   Thermal
> event interrupts
>   THR:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0   Threshold
> APIC interrupts
>   MCE:          0          0          0          0          0
> 0          0          0          0          0          0          0
>        0          0          0          0          0          0
>   0          0          0          0          0          0   Machine
> check exceptions
>   MCP:          2          2          2          2          2
> 2          2          2          2          2          2          2
>        2          2          2          2          2          2
>   2          2          2          2          2          2   Machine
> check polls
>   ERR:          0
>   MIS:          0
> =====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====
>
> I am happy testing patches, and running any unit-tests.
>
> Thanks in advance,
>
> -Bryan

