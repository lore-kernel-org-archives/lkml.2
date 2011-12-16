Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078Ab1LPDkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 22:40:11 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41023 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab1LPDkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 22:40:09 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5 machine
In-Reply-To: <1323980706.1984.255.camel@sbsiddha-desk.sc.intel.com>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com> <alpine.LFD.2.02.1112141423380.3020@ionos> <alpine.LFD.2.02.1112142116540.3020@ionos> <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com> <87y5ueo9m5.fsf@abhimanyu.in.ibm.com> <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com> <20111215071901.GF14237@elte.hu> <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com> <1323980706.1984.255.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Fri, 16 Dec 2011 09:11:19 +0530
Message-ID: <87aa6t89pc.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121603-2000-0000-0000-000005B9B2D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011 12:25:06 -0800, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Thu, 2011-12-15 at 11:16 -0800, Yinghai Lu wrote:
> > On Wed, Dec 14, 2011 at 11:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > * Yinghai Lu <yinghai@kernel.org> wrote:
> > >
> > >> On Wed, Dec 14, 2011 at 6:24 PM, Nikunj A Dadhania
> > >> <nikunj@linux.vnet.ibm.com> wrote:
> > >> >>
> > >> >> BIOS pre-enabled x2apic, and kernel config does not have x2apic enabled?
> > >> > make oldconfig somehow skipped this!! I can see my previous kernel config
> > >> > having this enabled.
> > >>
> > >> looks like recent dmar table related DMAR changing cause that.
> > >
> > > Which one would that be? Perhaps:
> > >
> > >      iommu: Rename the DMAR and INTR_REMAP config options
> > >
> > > ? They then need to be fixed if it can be done sanely.
> > 
> > yes.
> 
> Not quite sure if I understand the reported issue.
> 
> If the old config file had CONFIG_X86_X2APIC and CONFIG_INTR_REMAP set,
> doing "make oldconfig" on the newer kernel is asking if I want the new
> CONFIG_IRQ_REMAP option to be set and if I say yes, then I have both
> CONFIG_X86_X2APIC and CONFIG_IRQ_REMAP set and all is well.
> 
> But if I say no, then as expected CONFIG_X86_X2APIC gets disabled (as
> IRQ_REMAP is not selected).
Yes, my bad, I was expecting this in processor type and features, but
that is now in IOMMU.

Thanks,
Nikunj

