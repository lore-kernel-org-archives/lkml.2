Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab1LOQHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:07:23 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:47514 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942Ab1LOQHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:07:22 -0500
Message-ID: <4EEA18A8.5030603@ladisch.de>
Date: Thu, 15 Dec 2011 16:56:24 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Julian Sikorski <belegdol@gmail.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: bug report: irq 19: nobody cared (try booting with the "irqpoll"
 option)
References: <4EEA0485.4050105@gmail.com> <4EEA0521.2030502@gmail.com>
In-Reply-To: <4EEA0521.2030502@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC linux1394-devel)

Julian Sikorski wrote:
> W dniu 15.12.2011 15:30, Julian Sikorski pisze:
>> this is happening every time I reboot from suspend on a Clevo P150HM
>> machine. It has been occuring for a while, but this report is for Fedora
>> kernel 3.1.5-2.fc16 (I am running an up-to-date Fedora 16 x86_64 here).
>> Smolt profile is available here:
>>
>> http://www.smolts.org/client/show/pub_1eec606f-137a-46a1-922f-98f40180efa6
>>
>> I have the problem itself does not seem to manifest in anything else
>> except abrt complaining.

Your FireWire won't work.

>> irq 19: nobody cared (try booting with the "irqpoll" option)

> 05:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller (prog-if 10 [OHCI])
>         Subsystem: CLEVO/KAPOK Computer Device 5102
>         Physical Slot: 1
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 19
>         Region 0: Memory at f6103000 (32-bit, non-prefetchable) [size=2K]
>         Region 1: Memory at f6102000 (32-bit, non-prefetchable) [size=128]
>         Region 4: Memory at f6101000 (32-bit, non-prefetchable) [size=128]
>         Region 5: Memory at f6100000 (32-bit, non-prefetchable) [size=128]
>         Capabilities: <access denied>
>         Kernel driver in use: firewire_ohci
>         Kernel modules: firewire-ohci

>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7
> ...
>  18:          0          0          0          0          0          0          0          0  IR-IO-APIC-fasteoi   jmb38x_ms:slot0, mmc0
>  19:     100008          0          0          0          0          0          0          0  IR-IO-APIC-fasteoi   firewire_ohci
> ...
>  40:          0          0          0          0          0          0          0          0  DMAR_MSI-edge      dmar0
> ...

Was it the JMB38x that used a wrong interface number in its PCIe
transactions, which would make the I/O-MMU map it to the wrong device?

Julian, try disabling DMAR (probably called IOMMU or something related
to virtualization) in the BIOS.


Regards,
Clemens
