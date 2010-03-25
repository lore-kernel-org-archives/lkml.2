Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0CYKg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:36:28 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:37563 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0CYKgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=YSyCBMotR/Qut+ti/UpyTSZr9xHunZiw3iqYkIzRoTodjh3OXZSbO8pKyRXV/ROjI+
         RewsLa57vtjBSJHmJaKy5e+jfZ1QOTNsxkg0sfQCJ+i/WB2RxQzWh/8OI3fQEFPpm+zV
         qaSu8dLxJwT+VI2kQbZxfBLMYEHWjS27b72fg=
Date: Thu, 25 Mar 2010 11:36:18 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: James Lamanna <jlamanna@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hardware Interrupt Balancing
Message-ID: <20100325113618.024b8643@varda>
In-Reply-To: <aa4c40ff1003241811p151a3aaakad1798c64ab29d24@mail.gmail.com>
References: <aa4c40ff1003241811p151a3aaakad1798c64ab29d24@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 24 Mar 2010 18:11:36 -0700
James Lamanna <jlamanna@gmail.com> escribió:

> Hi,
> I have a Dual Xeon (single core each w/HT) machine and I noticed the
> other day that interrupts are not
> being balanced across the 2 processors:
> 
>           CPU0       CPU1       CPU2       CPU3
>   0:        306          0          0 3254413993    IO-APIC-edge  timer
>   1:          0          0          0      13468    IO-APIC-edge  i8042
>   8:          0          0          0          3    IO-APIC-edge  rtc
>   9:          0          0          0          0   IO-APIC-level  acpi
>  12:          0          0          0          4    IO-APIC-edge  i8042
> 169:          0          0          0          0   IO-APIC-level  uhci_hcd:usb2
> 177:          0          0          0   16743166   IO-APIC-level  ata_piix
> 185:          0          0          0          1   IO-APIC-level  ehci_hcd:usb1
> 193:          0          0          0          0   IO-APIC-level  uhci_hcd:usb3
> 201:          0          0          0 1867922172   IO-APIC-level  eth0
> 209:          0          0          0 3254690559   IO-APIC-level  wct4xxp
> NMI:          1          0          0          0
> LOC: 3255261535 3255261540 3255261549 3255220504
> ERR:          0
> MIS:          0
> 
> However the cpu_affinity of say, wct4xxp is:
> # cat /proc/irq/209/smp_affinity
> 0000000f

 Maybe you just need to run irqbalance http://www.irqbalance.org/
 « sudo aptitude install irqbalance » in Debian system


> 
> Is there something (CPU Hotplug?) preventing the hardware interrupts
> from being balanced across both CPUs?
> The kernel version is 2.6.18 (i686) (this is an older machine that is
> a PSTN<->SIP gateway).
> 
> Thanks.
> 
> -- James
> 
> Please CC me for I am not subscribed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
