Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196Ab1LPIm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:42:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38593 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139Ab1LPIm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:42:28 -0500
Date: Fri, 16 Dec 2011 09:40:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5
 machine
Message-ID: <20111216084029.GB4170@elte.hu>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
 <alpine.LFD.2.02.1112141423380.3020@ionos>
 <alpine.LFD.2.02.1112142116540.3020@ionos>
 <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
 <87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
 <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
 <20111215071901.GF14237@elte.hu>
 <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

>  config X86_X2APIC
>  	bool "Support x2apic"
> -	depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
> +	depends on X86_LOCAL_APIC && X86_64
> +	select IRQ_REMAP

IRQ_REMAP is a 'complex' option:

config IRQ_REMAP
        bool "Support for Interrupt Remapping (EXPERIMENTAL)"
        depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
        select DMAR_TABLE

and selecting such complex options is generally dangerous, as 
the sub-dependencies are not explicitly selected. So if say 
PCI_MSI or ACPI are disabled, the select will still be performed 
by X86_X2APIC.

Can we make the IRQ_REMAP default depend on X86_X2APIC or so, to 
solve this problem?

Thanks,

	Ingo
