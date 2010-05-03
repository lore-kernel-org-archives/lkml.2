Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab0ECXVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:21:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43133 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab0ECXVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:21:47 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
	<1269221770-9667-3-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003221131470.3147@localhost.localdomain>
	<m1iq8f1c1f.fsf@fess.ebiederm.org> <4BB0EA22.7000004@zytor.com>
	<m1r5n2wwah.fsf_-_@fess.ebiederm.org>
	<m1oci6qlmr.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 03 May 2010 16:21:33 -0700
In-Reply-To: <m1oci6qlmr.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 30 Mar 2010 01\:06\:20 -0700")
Message-ID: <m163348tc2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: hpa@zytor.com, protasnb@gmail.com, garyhade@us.ibm.com, iranna.ankad@in.ibm.com, linux-acpi@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com, len.brown@intel.com, suresh.b.siddha@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org, mingo@elte.hu, yinghai@kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/15] Start coping gsis < 16 that are not isa irqs. v2
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> It appears there are a few systems in the wild that use acpi
> interrupt source overrides to report a gsi > 16 is an isa irq.
>
> This breaks all kinds of assumptions I figure any BIOS doing that
> probably should be shot as that is very much not a conservative position.
>
> That said acpi appears to allow this insanity and on the basis of being
> liberal in what we accept we should try to do something reasonable, and
> keep our notions of gsi, isa irq, and linux irq as straight as we can.
>
> To that end this patchset slightly modifies the gsi to linux irq
> mapping.  Making it a 1 to 1 identity mapping except for the first 16
> gsis.  If those gsis are isa irqs (the typical and default acpi
> configuration) they will be mapped into the first 16 irqs.  If those
> first 16 gsis are not isa irqs they will be given a linux irq number
> just past the last gsi.  Allowing us the chance to use them.
>
> This patchset is my attempt to straighten out our understanding of which
> kind of irq name is used where and the cleanups used to get there.
>
> Thanks to Yinghai Lu <yinghai@kernel.org> for taking the first stab at
> this and finding that there is a real world problem here.  This patchset
> is inspired by his work, but little of it remains the same.
>
> This patchset lies in the weird world between the acpi and x86 and ia64.
> Since most of the changes are x86 related I think it makes most sense
> to go via the x86 tree.
>
> v2: Recognize that gsi_end is last gsi for an ioapic not one past the end.
>     Since I use gsi_end widely in my patchset a respin of many of the patches
>     made sense.
>
> Eric W. Biederman (15):
>       x86 acpi/irq: Introduce apci_isa_irq_to_gsi
>       x86 acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq
>       x86 acpi/irq: pci device dev->irq is an isa irq not a gsi
>       x86 acpi/irq: Fix acpi_sci_ioapic_setup so it has both bus_irq and gsi
>       x86 acpi/irq: Generalize mp_config_acpi_legacy_irqs
>       x86 ioapic: Only export mp_find_ioapic and mp_find_ioapic_pin in io_apic.h
>       x86 ioapic: Fix io_apic_redir_entries to return the number of entries.
>       x86 ioapic: Fix the types of gsi values
>       x86 ioapic: Teach mp_register_ioapic to compute a global gsi_end
>       x86 ioapic: In mpparse use mp_register_ioapic
>       x86 ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.
>       x86 ioapic: Optimize pin_2_irq
>       x86 ioapic: Simplify probe_nr_irqs_gsi.
>       x86 acpi/irq: Handle isa irqs that are not identity mapped to gsi's.
>       x86 irq: Kill io_apic_renumber_irq
>
>  arch/ia64/kernel/acpi.c          |    8 ++
>  arch/x86/include/asm/io_apic.h   |   12 ++--
>  arch/x86/include/asm/mpspec.h    |   10 ---
>  arch/x86/kernel/acpi/boot.c      |  133 ++++++++++++++++++++++++--------------
>  arch/x86/kernel/apic/es7000_32.c |   19 ------
>  arch/x86/kernel/apic/io_apic.c   |   99 +++++++++++++---------------
>  arch/x86/kernel/mpparse.c        |   25 +-------
>  arch/x86/kernel/sfi.c            |    4 +-
>  drivers/acpi/pci_irq.c           |    8 ++-
>  include/linux/acpi.h             |    5 +-
>  10 files changed, 154 insertions(+), 169 deletions(-)

ping

Where are we at with this patchset?

Eric

