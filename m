Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0HTPxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:53:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60903 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0HTPxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=k/Umxnq/5rUYWdKccyDHK3RWXGLprq8WAkCmqmD/aM+DOPvgXh/NtE2+eO5twjPpmr
         vYkw+h253F1rsxfxvh5TFWebBXRzge5P2u4wGafzbcawAHtzUoBh/y9ijuQ1kWZVXLnX
         1Ynqnbb7n29eKT1JrKzVYhUFyg9zcggvEhB3E=
MIME-Version: 1.0
Date: Fri, 20 Aug 2010 08:53:15 -0700
Message-ID: <AANLkTi=9HOsir_kt5AxNr5CfKKMPsakmhPQc+=xqHXi1@mail.gmail.com>
Subject: 2.6.35-rc1-git2 -- ACPI Error: Attempt to CreateField of length zero (20100702/dsopcode-529)
From: Miles Lane <miles.lane@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject:    Re: 2.6.33-rc5-git2 -- ACPI Error: Attempt to CreateField of
> From:       Lin Ming <ming.m.lin () intel ! com>
> Date:       2010-01-28 3:12:00
> On Wed, 2010-01-27 at 20:43 +0800, Miles Lane wrote:
> > On Wed, Jan 27, 2010 at 3:04 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > >
> > >> From: Miles Lane <miles.lane@gmail.com>
> > >> Date: Wed, Jan 27, 2010 at 2:54 PM
> > >> Subject: 2.6.33-rc5-git2 -- ACPI Error: Attempt to CreateField of
> > >> length zero (20091214/dsopcode-529)
> > >> To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>, LKML
> > >> <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
> > >>
> > >>
> > >> I am not sure how much of this is due to a single cause.  Please let
> > >> me know if you'd like me to send separate reports.
> > >>
> > >> ACPI: EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
> > >> ACPI Warning: Incorrect checksum in table [ATKG] - FA, should be 05
> > >> (20091214/tbutils-314)
> > >>
> > >> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > >> ACPI Error: Attempt to CreateField of length zero (20091214/dsopcode-529)
> > >> ACPI Error (psparse-0537): Method parse/execution failed
> > >> [\_SB_.PCI0.IDE0.RATA] (Node ffff88013f81a9e0), AE_AML_OPERAND_VALUE
> > >> ACPI Error (psparse-0537): Method parse/execution failed
> > >> [\_SB_.PCI0.IDE0.PRT1._GTF] (Node ffff88013f81ab20),
> > >> AE_AML_OPERAND_VALUE
> > >> ata2.00: _GTF evaluation failed (AE 0x3004)
> > >> ata2.00: ATAPI: MATSHITADVD-RAM UJ892AS, 1.00, max UDMA/100, ATAPI AN
> > >> ACPI Error: Attempt to CreateField of length zero (20091214/dsopcode-529)
> > >> ACPI Error (psparse-0537): Method parse/execution failed
> > >> [\_SB_.PCI0.IDE0.RATA] (Node ffff88013f81a9e0), AE_AML_OPERAND_VALUE
> > >> ACPI Error (psparse-0537): Method parse/execution failed
> > >> [\_SB_.PCI0.IDE0.PRT1._GTF] (Node ffff88013f81ab20),
> > >> AE_AML_OPERAND_VALUE
> > >> ata2.00: _GTF evaluation failed (AE 0x3004)
> > >> ata2.00: configured for UDMA/100
> > >> scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ892AS  1.00 PQ: 0 ANSI: 5
> > >>
> > >
> > > >From the DSDT,
> > >
> > >  2522                 Method (RATA, 1, NotSerialized)
> > >  2523                 {
> > >  2524                     CreateByteField (Arg0, Zero, CMDN)
> > >  2525                     Multiply (CMDN, 0x38, Local0)
> > >  2526                     CreateField (Arg0, 0x08, Local0, RETB)
> > >  2527                     Store (RETB, Debug)
> > >  2528                     Return (RETB)
> > >  2529                 }
> > >
> > >  2546                 Name (ATP1, Buffer (0x32) {})
> > >  2547                 Device (PRT1)
> > >  2548                 {
> > >  2549                     Name (_ADR, 0x0001FFFF)
> > >  2550                     Method (_SDD, 1, NotSerialized)
> > >  2551                     {
> > >  2552                         Store (AGTF (Zero, Arg0), ATP1)
> > >  2553                     }
> > >  2554
> > >  2555                     Method (_GTF, 0, NotSerialized)
> > >  2556                     {
> > >  2557                         Return (RATA (ATP1))
> > >  2558                     }
> > >  2559                 }
> > >
> > > It seems that ATP1 is not set correctly in PRT1._SDD.
> > > Then ATP1 is passed into RATA and CMDN is created with value zero.
> > > That causes the error message.
> >
> > This is the current BIOS for the ASUS UL50VT.  Is this something that gets
> > fixed by a BIOS update?  Do you have a way to pass this information on to
> > ASUS?  Is there something the kernel code can do to work around the
> > problem, or is that already happening?
>
> Is this bug a regression? Did you see it with older kernel?
> If yes, could you do a bisect?

As far as I know, this problem is not a regression. I suppose I could
try building an old kernel tree (2.6.30 or suchlike).
The problem still show up in the current Linus tree (2.6.36-rc1-git2.

Miles
