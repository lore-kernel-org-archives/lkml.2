Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178Ab1LPIic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:38:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1LPIib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:38:31 -0500
Date: Fri, 16 Dec 2011 09:36:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5
 machine
Message-ID: <20111216083634.GA4170@elte.hu>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
 <alpine.LFD.2.02.1112141423380.3020@ionos>
 <alpine.LFD.2.02.1112142116540.3020@ionos>
 <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
 <87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
 <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
 <20111215071901.GF14237@elte.hu>
 <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
 <1323980706.1984.255.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323980706.1984.255.camel@sbsiddha-desk.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> > yes.
> 
> Not quite sure if I understand the reported issue.
> 
> If the old config file had CONFIG_X86_X2APIC and 
> CONFIG_INTR_REMAP set, doing "make oldconfig" on the newer 
> kernel is asking if I want the new CONFIG_IRQ_REMAP option to 
> be set and if I say yes, then I have both CONFIG_X86_X2APIC 
> and CONFIG_IRQ_REMAP set and all is well.
> 
> But if I say no, then as expected CONFIG_X86_X2APIC gets 
> disabled (as IRQ_REMAP is not selected).

The problem is spuriously re-asking a question that *has already 
been answered by the user*, and if the user accidentally just 
accepts the default, the config breaks.

We try to keep things working fine across 'make oldconfig', i.e. 
if the .config worked before, it should work after a 'make 
oldconfig' as well.

Thanks,

	Ingo
