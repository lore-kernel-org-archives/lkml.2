Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab1LOUUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 15:20:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:65432 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1LOUUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 15:20:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87818395"
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on
 x3850x5 machine
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 15 Dec 2011 12:25:06 -0800
In-Reply-To: <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
	 <alpine.LFD.2.02.1112141423380.3020@ionos>
	 <alpine.LFD.2.02.1112142116540.3020@ionos>
	 <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
	 <87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
	 <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
	 <20111215071901.GF14237@elte.hu>
	 <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323980706.1984.255.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 11:16 -0800, Yinghai Lu wrote:
> On Wed, Dec 14, 2011 at 11:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> >
> >> On Wed, Dec 14, 2011 at 6:24 PM, Nikunj A Dadhania
> >> <nikunj@linux.vnet.ibm.com> wrote:
> >> >>
> >> >> BIOS pre-enabled x2apic, and kernel config does not have x2apic enabled?
> >> > make oldconfig somehow skipped this!! I can see my previous kernel config
> >> > having this enabled.
> >>
> >> looks like recent dmar table related DMAR changing cause that.
> >
> > Which one would that be? Perhaps:
> >
> >      iommu: Rename the DMAR and INTR_REMAP config options
> >
> > ? They then need to be fixed if it can be done sanely.
> 
> yes.

Not quite sure if I understand the reported issue.

If the old config file had CONFIG_X86_X2APIC and CONFIG_INTR_REMAP set,
doing "make oldconfig" on the newer kernel is asking if I want the new
CONFIG_IRQ_REMAP option to be set and if I say yes, then I have both
CONFIG_X86_X2APIC and CONFIG_IRQ_REMAP set and all is well.

But if I say no, then as expected CONFIG_X86_X2APIC gets disabled (as
IRQ_REMAP is not selected).

> @@ -287,7 +287,7 @@ config SMP
> 
>  config X86_X2APIC
>         bool "Support x2apic"
> -       depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
> +       depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
>         ---help---
>           This enables x2apic support on CPUs that have this feature.
> 
> 
> renaming INTR_REMAP IRQ_REMAP cause that.
> 
> Attached patch should fix the problem.
> 

While I am ok with the proposed patch (we are going back to the original
behavior which minimizes the number of options that the user need to
select), I am not sure if I understand the problem.

FWIW, Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

