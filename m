Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0CYBLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:11:46 -0400
Received: from mail-px0-f181.google.com ([209.85.216.181]:62241 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab0CYBLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tZLiNvaLGrzNrdeF1snYGZnX9+aLALt4BjjsKPIWDIKPp0UGV1xVb+jyhkKq6iL685
         gHo38A962+lpgsD3RE8ZtTAmMolGPQpcwcLxL1d4QTEHhtUndF7IrLedPQVQ3wFkKrB2
         bmaAAUbujlACGcPVYUaKnG4cvNDAFWAeDD/Lk=
MIME-Version: 1.0
Date: Wed, 24 Mar 2010 18:11:36 -0700
Message-ID: <aa4c40ff1003241811p151a3aaakad1798c64ab29d24@mail.gmail.com>
Subject: Hardware Interrupt Balancing
From: James Lamanna <jlamanna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a Dual Xeon (single core each w/HT) machine and I noticed the
other day that interrupts are not
being balanced across the 2 processors:

          CPU0       CPU1       CPU2       CPU3
  0:        306          0          0 3254413993    IO-APIC-edge  timer
  1:          0          0          0      13468    IO-APIC-edge  i8042
  8:          0          0          0          3    IO-APIC-edge  rtc
  9:          0          0          0          0   IO-APIC-level  acpi
 12:          0          0          0          4    IO-APIC-edge  i8042
169:          0          0          0          0   IO-APIC-level  uhci_hcd:usb2
177:          0          0          0   16743166   IO-APIC-level  ata_piix
185:          0          0          0          1   IO-APIC-level  ehci_hcd:usb1
193:          0          0          0          0   IO-APIC-level  uhci_hcd:usb3
201:          0          0          0 1867922172   IO-APIC-level  eth0
209:          0          0          0 3254690559   IO-APIC-level  wct4xxp
NMI:          1          0          0          0
LOC: 3255261535 3255261540 3255261549 3255220504
ERR:          0
MIS:          0

However the cpu_affinity of say, wct4xxp is:
# cat /proc/irq/209/smp_affinity
0000000f

Is there something (CPU Hotplug?) preventing the hardware interrupts
from being balanced across both CPUs?
The kernel version is 2.6.18 (i686) (this is an older machine that is
a PSTN<->SIP gateway).

Thanks.

-- James

Please CC me for I am not subscribed.
