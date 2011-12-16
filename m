Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354Ab1LPSDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:03:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35706 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1LPSDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:03:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111216084029.GB4170@elte.hu>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
	<alpine.LFD.2.02.1112141423380.3020@ionos>
	<alpine.LFD.2.02.1112142116540.3020@ionos>
	<CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
	<87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
	<CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
	<20111215071901.GF14237@elte.hu>
	<CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
	<20111216084029.GB4170@elte.hu>
Date: Fri, 16 Dec 2011 10:03:46 -0800
X-Google-Sender-Auth: Hnnf6iwvcSEkWbvKwv_RaNQoWOo
Message-ID: <CAE9FiQWzqTGLq2-8Zn4bydCxqA6JL0JVQyDzCtadUCt8nwNWnQ@mail.gmail.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5 machine
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 12:40 AM, Ingo Molnar <mingo@elte.hu> wrote:

> IRQ_REMAP is a 'complex' option:
>
> config IRQ_REMAP
>        bool "Support for Interrupt Remapping (EXPERIMENTAL)"
>        depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
>        select DMAR_TABLE
>
> and selecting such complex options is generally dangerous, as
> the sub-dependencies are not explicitly selected. So if say
> PCI_MSI or ACPI are disabled, the select will still be performed
> by X86_X2APIC.
>
> Can we make the IRQ_REMAP default depend on X86_X2APIC or so, to
> solve this problem?

but user could use IRQ_REMAP without x2apic.

We could have

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -286,7 +286,8 @@ config SMP

 config X86_X2APIC
        bool "Support x2apic"
-       depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
+       depends on X86_LOCAL_APIC && X86_64 && X86_IO_APIC && PCI_MSI && ACPI
+       select IRQ_REMAP
        ---help---
          This enables x2apic support on CPUs that have this feature.

BTW:
Suresh, can we remove EXPERIMENTAL for IRQ_REMAP now?

Thanks

Yinghai
