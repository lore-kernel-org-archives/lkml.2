Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0GRSSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 14:18:14 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:25788 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab0GRSSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 14:18:12 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432N98dN936eMzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5RMTV-02-4EF-02
X-M-MSG: 
Date: Sun, 18 Jul 2010 20:17:36 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Heinz Diehl <htd@fancy-poultry.org>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100718181736.GA10886@aftab>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
 <20100718162239.GA21151@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100718162239.GA21151@fancy-poultry.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Diehl <htd@fancy-poultry.org>
Date: Sun, Jul 18, 2010 at 12:22:39PM -0400

> On 15.07.2010, Michal Schmidt wrote: 
> 
> > This suggests that another way to fix my problem would be this (tested):
> [....]
> 
> Did apply this patch to stock 2.6.35-rc5, it does _not_ fix my C1E problem.
> It takes a lot of key pressing in the boot process to get the system up,
> just as it has been before.

Well, no wonder it wouldn't work - you seem to have that funny Gigabyte
BIOS which botches lapic and ioapic id enumeration and obviously
enabling C1E in the SMI handler (excerpt from your dmesg):

ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23

See how the IOAPIC's and the third LAPIC's ids are the same?
That's wrong. There are couple people with the same problem:
https://bugzilla.kernel.org/show_bug.cgi?id=15289. And as comment #53
says, we're trying to talk to Gigabyte to fix this and the C1E problem.
For now, you can disable C1E in the BIOS, use "idle=mwait" and put
yourself on the CC list of that bug. Sorry, I wish I could give you
better news.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

