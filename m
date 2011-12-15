Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab1LOQEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:04:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54548 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759005Ab1LOQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:04:20 -0500
Message-ID: <4EEA1A81.6030807@gmail.com>
Date: Thu, 15 Dec 2011 17:04:17 +0100
From: Julian Sikorski <belegdol@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: bug report: irq 19: nobody cared (try booting with the "irqpoll"
 option)
References: <4EEA0485.4050105@gmail.com> <4EEA0521.2030502@gmail.com> <4EEA18A8.5030603@ladisch.de>
In-Reply-To: <4EEA18A8.5030603@ladisch.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 15.12.2011 16:56, Clemens Ladisch pisze:
> (CC linux1394-devel)
> 
> Julian Sikorski wrote:
>> W dniu 15.12.2011 15:30, Julian Sikorski pisze:
>>> this is happening every time I reboot from suspend on a Clevo P150HM
>>> machine. It has been occuring for a while, but this report is for Fedora
>>> kernel 3.1.5-2.fc16 (I am running an up-to-date Fedora 16 x86_64 here).
>>> Smolt profile is available here:
>>>
>>> http://www.smolts.org/client/show/pub_1eec606f-137a-46a1-922f-98f40180efa6
>>>
>>> I have the problem itself does not seem to manifest in anything else
>>> except abrt complaining.
> 
> Your FireWire won't work.

Unfortunately I do not have any FW device around to test.
> 
>>> irq 19: nobody cared (try booting with the "irqpoll" option)
> 
>> 05:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller (prog-if 10 [OHCI])
>>         Subsystem: CLEVO/KAPOK Computer Device 5102
>>         Physical Slot: 1
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 19
>>         Region 0: Memory at f6103000 (32-bit, non-prefetchable) [size=2K]
>>         Region 1: Memory at f6102000 (32-bit, non-prefetchable) [size=128]
>>         Region 4: Memory at f6101000 (32-bit, non-prefetchable) [size=128]
>>         Region 5: Memory at f6100000 (32-bit, non-prefetchable) [size=128]
>>         Capabilities: <access denied>
>>         Kernel driver in use: firewire_ohci
>>         Kernel modules: firewire-ohci
> 
>>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7
>> ...
>>  18:          0          0          0          0          0          0          0          0  IR-IO-APIC-fasteoi   jmb38x_ms:slot0, mmc0
>>  19:     100008          0          0          0          0          0          0          0  IR-IO-APIC-fasteoi   firewire_ohci
>> ...
>>  40:          0          0          0          0          0          0          0          0  DMAR_MSI-edge      dmar0
>> ...
> 
> Was it the JMB38x that used a wrong interface number in its PCIe
> transactions, which would make the I/O-MMU map it to the wrong device?
> 
> Julian, try disabling DMAR (probably called IOMMU or something related
> to virtualization) in the BIOS.

There is no such option or anything even remotely related in the BIOS
(this machine uses the AMI Aptio if that matters).
> 
> 
> Regards,
> Clemens

Just to make it clear, booting with irqpoll option made the message go away.

Regards,
Julian
