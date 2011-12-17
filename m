Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780Ab1LQCN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 21:13:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:10542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1LQCNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 21:13:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="87517455"
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on
 x3850x5 machine
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 16 Dec 2011 18:18:09 -0800
In-Reply-To: <CAE9FiQWzqTGLq2-8Zn4bydCxqA6JL0JVQyDzCtadUCt8nwNWnQ@mail.gmail.com>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
	 <alpine.LFD.2.02.1112141423380.3020@ionos>
	 <alpine.LFD.2.02.1112142116540.3020@ionos>
	 <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
	 <87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
	 <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
	 <20111215071901.GF14237@elte.hu>
	 <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
	 <20111216084029.GB4170@elte.hu>
	 <CAE9FiQWzqTGLq2-8Zn4bydCxqA6JL0JVQyDzCtadUCt8nwNWnQ@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324088289.1984.305.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 10:03 -0800, Yinghai Lu wrote:
> On Fri, Dec 16, 2011 at 12:40 AM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > IRQ_REMAP is a 'complex' option:
> >
> > config IRQ_REMAP
> >        bool "Support for Interrupt Remapping (EXPERIMENTAL)"
> >        depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
> >        select DMAR_TABLE
> >
> > and selecting such complex options is generally dangerous, as
> > the sub-dependencies are not explicitly selected. So if say
> > PCI_MSI or ACPI are disabled, the select will still be performed
> > by X86_X2APIC.
> >
> > Can we make the IRQ_REMAP default depend on X86_X2APIC or so, to
> > solve this problem?
> 
> but user could use IRQ_REMAP without x2apic.

Ingo's recommendation is for the default value. We can have multiple
default conditions and the user can always override.

So I am ok with Ingo's suggestion.

> BTW:
> Suresh, can we remove EXPERIMENTAL for IRQ_REMAP now?

Like Google products, beta for a long time ;)

Seriously, we can plan to remove this experimental in the next release.

thanks,
suresh


