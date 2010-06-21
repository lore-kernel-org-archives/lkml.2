Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0FUQyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:54:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48359 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758034Ab0FUQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:54:50 -0400
Subject: Re: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI
 related?]
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <1277138034.10998.69.camel@mulgrave.site>
References: <1277136189.10998.63.camel@mulgrave.site>
	 <87pqzkqrzq.fsf@basil.nowhere.org>
	 <1277138034.10998.69.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 11:54:46 -0500
Message-ID: <1277139286.10998.72.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 11:33 -0500, James Bottomley wrote:
> On Mon, 2010-06-21 at 18:18 +0200, Andi Kleen wrote:
> > James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> > 
> > > The system in question has a set of root bridges, with the CD rom (which
> > > is seen) being on bus 0 and the SCSI controller, which doesn't show up
> > > being on bus 1 (with several other things on busses > 1).
> > >
> > > The system uses ACPI to detect the multiple bridges, so it seems that
> > > this failure in 2.6.35-rc3:
> > >
> > > ACPI: Core revision 20100428
> > > ACPI Error: Hardware did not enter ACPI mode (20100428/evxfevnt-103)
> > > ACPI Warning: AcpiEnable failed (20100428/utxface-147)
> > > ACPI: Unable to enable ACPI
> > 
> > That probably causes all the other problems. Without ACPI enabled
> > modern systems generally do not work.
> > 
> > Just guessing, but maybe try to revert
> > 
> > b430acbd7c4b919886fa7fd92eeb7a695f1940d3
> > 
> > That was the last change in this area.
> 
> I can confirm that reverting this over a vanilla 2.6.35-rc3 fixes my
> boot problem.

Andi asked for the timings with the commit reverted, so here they are
(from ACPI version print to PCI root busses found):

[    0.084086] ACPI: Core revision 20100428
[    0.119779] Setting APIC routing to physical flat
[    0.124259] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.128000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.128000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.128000] ..... (found apic 0 pin 2) ...
[    0.128000] ....... failed.
[    0.128000] ...trying to set up timer as Virtual Wire IRQ...
[    0.169681] ..... works.
[    0.172005] CPU0: Intel(R) Xeon(TM) MP CPU 3.16GHz stepping 01
[    0.188000] lockdep: fixing up alternatives.
[    0.188133] Booting Node   0, Processors  #1 Ok.
[    0.288089] Brought up 2 CPUs
[    0.292006] Total of 2 processors activated (12676.86 BogoMIPS).
[    0.300923] khelper used greatest stack depth: 5864 bytes left
[    0.305017] khelper used greatest stack depth: 5176 bytes left
[    0.325510] NET: Registered protocol family 16
[    0.341322] ACPI: bus type pci registered
[    0.344474] PCI: Using configuration type 1 for base access
[    0.359165] bio: create slab <bio-0> at 0
[    0.478153] ACPI: Interpreter enabled
[    0.488006] ACPI: (supports S0 S5)
[    0.497875] ACPI: Using IOAPIC for interrupt routing
[    0.548145] ACPI: No dock devices found.
[    0.552176] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.556263] ACPI: PCI Root Bridge [VP00] (domain 0000 [bus 00])
[    0.568051] ACPI: PCI Root Bridge [VP01] (domain 0000 [bus 01])
[    0.576336] ACPI: PCI Root Bridge [VP02] (domain 0000 [bus 02-03])
[    0.596889] ACPI: PCI Root Bridge [VP03] (domain 0000 [bus 04-05])
[    0.605222] ACPI: PCI Root Bridge [VP04] (domain 0000 [bus 06-07])
[    0.613530] ACPI: PCI Root Bridge [VP05] (domain 0000 [bus 08-09])
[    0.617658] ACPI: PCI Root Bridge [VP06] (domain 0000 [bus 0a-0b])
[    0.621672] ACPI: PCI Root Bridge [VP07] (domain 0000 [bus 0c-0d])
[    0.625948] HEST: Table is not found!

James


