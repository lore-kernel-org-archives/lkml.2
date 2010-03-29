Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0C2UOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:14:52 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:49864 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0C2UOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=ne1GxJzzcNAsQ9CjyHE/FQ2E0ffFFwGSHOAPKMT3KcDID5DYeE+Fk0cSgSMPe2Rx1R
         4GJ8WEAOc29iTH7vhlF5/X/GQw7N4+IaEV+I0f/PPtzcOblGHbxFEfHf9tOVTaFpvGl6
         37SND37S/sQPWywFOFlDq6N3RU9P9j5SiJ6VM=
References: <aa4c40ff1003241811p151a3aaakad1798c64ab29d24@mail.gmail.com> <20100325113618.024b8643@varda>
Message-Id: <8E1CBD32-5DCE-4931-A0AB-6713229193D2@gmail.com>
From: James Lamanna <jlamanna@gmail.com>
To: =?utf-8?Q?Alejandro_Riveira_Fern=C3=A1ndez?= <ariveira@gmail.com>
In-Reply-To: <20100325113618.024b8643@varda>
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 8BIT
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: Hardware Interrupt Balancing
Date: Mon, 29 Mar 2010 13:14:35 -0700
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--James

On Mar 25, 2010, at 3:36, Alejandro Riveira Fernández <ariveira@gmail.co 
m> wrote:

> El Wed, 24 Mar 2010 18:11:36 -0700
> James Lamanna <jlamanna@gmail.com> escribió:
>
>> Hi,
>> I have a Dual Xeon (single core each w/HT) machine and I noticed the
>> other day that interrupts are not
>> being balanced across the 2 processors:
>>
>>          CPU0       CPU1       CPU2       CPU3
>>  0:        306          0          0 3254413993    IO-APIC-edge   
>> timer
>>  1:          0          0          0      13468    IO-APIC-edge   
>> i8042
>>  8:          0          0          0          3    IO-APIC-edge  rtc
>>  9:          0          0          0          0   IO-APIC-level  acpi
>> 12:          0          0          0          4    IO-APIC-edge   
>> i8042
>> 169:          0          0          0          0   IO-APIC-level   
>> uhci_hcd:usb2
>> 177:          0          0          0   16743166   IO-APIC-level   
>> ata_piix
>> 185:          0          0          0          1   IO-APIC-level   
>> ehci_hcd:usb1
>> 193:          0          0          0          0   IO-APIC-level   
>> uhci_hcd:usb3
>> 201:          0          0          0 1867922172   IO-APIC-level   
>> eth0
>> 209:          0          0          0 3254690559   IO-APIC-level   
>> wct4xxp
>> NMI:          1          0          0          0
>> LOC: 3255261535 3255261540 3255261549 3255220504
>> ERR:          0
>> MIS:          0
>>
>> However the cpu_affinity of say, wct4xxp is:
>> # cat /proc/irq/209/smp_affinity
>> 0000000f
>
> Maybe you just need to run irqbalance http://www.irqbalance.org/
> « sudo aptitude install irqbalance » in Debian system

I do not want to use irq balance because everytime irqbalance moves  
the CPU of my PRI card, there is a hiccup in voice calls.
I manually moved the interrupts for the wct4xxp to CPU0 using  
smp_affinity = 1.

However today I got a lot of soft lockups on CPU0 due to asterisk in  
udp_sendmsg() - unsure if moving the interrupt caused this...could it?

Thanks.

-- James
>
