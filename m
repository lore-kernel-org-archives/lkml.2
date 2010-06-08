Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0FHUBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:01:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:49682 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab0FHUBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:01:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,386,1272870000"; 
   d="scan'208";a="286547344"
Date: Tue, 8 Jun 2010 20:12:58 +0100
From: Alan Cox <alan@linux.intel.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: jacob pan <jacob.jun.pan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
Message-ID: <20100608201258.6c813085@linux.intel.com>
In-Reply-To: <m1631tfh1i.fsf@fess.ebiederm.org>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The issue is what acpi calls bus 0 irqs, and how drivers deal with
> them.  We wind up having well know irqs:  irqs 3 and 4 for serial
> ports, irq 7 for parallel ports. irqs 14, and 15 for ide.

Only we don't.

IRQ 3/4 for serial is not true on many boxes today that have serial -
in fact its been iffy since about the Thinkpad 600 !
IRQ 7 for parallel is rarely used (and in fact we usually poll)
IRQ 14/15 is wrong for ATA today as its AHCI based on modern boxes

And all the drivers you list are *cross platform* already.

> A bunch of these hardware devices we can get if someone connects up a
> lpc superio chip.

To an x86 PC class system using some very traditional (and no longer
valid) bits of behaviour.

> Even if sfi is never implemented on a platform where that kind of
> hardware exists, the current sfi code is setup to coexist
> simultaneously in the kernel with all of the infrastructure of other
> platforms where those kinds of devices exist.  Which means there can
> be drivers compiled into your kernel that make assumptions about
> special properties of the irqs 0-15.

That would be a driver bug. It would be bite other systems beyond the
legacy PC. In the PC world its been unsafe since PnP BIOS let alone
ACPI.

> With the current code you should get all of the remapping of the
> gsi's out of the legacy irq space without needing to lift a finger,
> and if someone later decides we need an irq override so we can have
> an isa irq present on a weird embedded system on a chip the code will
> be able to handle that easily.

There is only one reason to care about this - that is ISA bus devices
with software IRQ steering registers for the ISA lines. Now that might
just about be a real reason, but as former maintainer of both serial
and IDE (and part time fixer of parport) I'd say the other reasons are
bunkum.

Alan
--
