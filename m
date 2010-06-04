Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab0FDDmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:42:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54222 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab0FDDmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JvEbmaaGfiC3UQFQODdwXmjwBnVtlUtdVbR65KBk3o38hNdJSzAwj0/z5ZinP/Ycx3
         7pn5e5IkZQn8JBE/vQggvcsN2OHmgEV3zL225uydYW3J6oowP+S+UvjE7+cE0/68JCU1
         e+FbKzs2bHJjwdiAaryCcChqEEe45vUIYPk5U=
Message-ID: <4C08760B.8050002@gmail.com>
Date: Thu, 03 Jun 2010 21:42:03 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marc Dionne <marc.c.dionne@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Subject: Re: Hang during boot, bisected to commit 96d60303fd
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com>	<20100603020006.GB19123@srcf.ucam.org> <AANLkTikpv86r5BBPCEOHujpm8uCgY0DxghSKjBufBWiM@mail.gmail.com>
In-Reply-To: <AANLkTikpv86r5BBPCEOHujpm8uCgY0DxghSKjBufBWiM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 07:21 PM, Marc Dionne wrote:
> On Wed, Jun 2, 2010 at 10:00 PM, Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>> On Wed, Jun 02, 2010 at 09:49:27PM -0400, Marc Dionne wrote:
>>>     Since somewhere early in the 2.6.35 merge window I've been seeing a hang
>>>     during boot.  The hang last roughly 30 seconds and is followed by this:
>>>
>>>     ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>>>     ata4.00: failed command: READ FPDMA QUEUED
>>>     ata4.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0 ncq 4096 in
>>>              res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>>     ata4.00: status: { DRDY }
>>>     ata4: hard resetting link
>>>     ahci_is_device_present: status is: 80
>>>     ahci_is_device_present: status(2) is: 3
>>>     ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>     ata4.00: configured for UDMA/133
>>>     ata4.00: device reported invalid CHS sector 0
>>>     ata4: EH complete
>>>
>>>     The system works normally once booted.  I had some time to do a bisect
>>>     today and it cleanly ended up pointing to this commit:
>>>         96d60303fd: ahci: Turn off DMA engines when there's no device attached
>>>
>>>     Reverting the commit makes the system boot cleanly as before.  System has
>>>     an Intel ICH10 based board, in AHCI mode, disk is an Intel X25M SSD.
>>
>> Hm, interesting. Jeff, any immediate ideas? I don't see this behaviour
>> on my ICH10. Is there actually a device on ata4?
>>
>> --
>> Matthew Garrett | mjg59@srcf.ucam.org
>
> If it's helpful, attached are the dmesg output following a normal boot
> and one with the hang.
>
> The only difference in the kernel used for those two boots is that the
> return statement in ahci_start_engine following the call to
> ahci_is_device_present is commented out for the normal boot case.
> When the return statement is active, the 30 second hang occurs.

Can you try and put a printk in where it's returning out of the 
ahci_start_engine method? I wonder if that's getting triggered somewhere 
unexpected..
