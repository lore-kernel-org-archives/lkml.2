Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab0LHBzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:55:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:16755 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab0LHBzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:55:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,313,1288594800"; 
   d="scan'208";a="581582735"
Date: Wed, 8 Dec 2010 09:52:59 +0800
From: Feng Tang <feng.tang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/platform] x86: Unify current 3 similar ways of saving
 IRQ info
Message-ID: <20101208095259.3668e1c7@feng-i7>
In-Reply-To: <4CFEE2D3.6050107@kernel.org>
References: <1291349518-3502-1-git-send-email-feng.tang@intel.com>
	<tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org>
	<4CFD226C.60308@kernel.org>
	<20101207133204.4d913c5a@feng-i7>
	<alpine.LFD.2.00.1012071654080.2653@localhost6.localdomain6>
	<4CFE8045.2030101@kernel.org>
	<alpine.LFD.2.00.1012072327000.2653@localhost6.localdomain6>
	<4CFEE2D3.6050107@kernel.org>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010 09:43:47 +0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On 12/07/2010 02:32 PM, Thomas Gleixner wrote:
> > On Tue, 7 Dec 2010, Yinghai Lu wrote:
> >> On 12/07/2010 07:56 AM, Thomas Gleixner wrote:
> >>>
> >>>   Same here. No caller is interested in the detailed return value.
> >>>
> >>
> > 
> >> ok, after look at code and git log, i knew the reasons for those
> >> strange duplicated functions.
> >>
> >> Alexy changed
> >>
> >>  /* MP IRQ source entries */
> >> -struct mpc_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
> >> +struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
> >>
> >> to make it decouple that with mpstable definition. so mptable will
> >> have mpc_intsrc, and acpi etc will use mp_config_intsrc
> >>
> >> and he planed to add more member to mp_config_intsrc .... never
> >> happened.
> >>
> >> then I added those functions with different parameters.
> >>
> >> one year later JSR changed all back to mpc_instr...
> >>
> >> so now have some duplicated functions....
> > 
> >> So yes, we should use simple versions in
> >> arch/x86/kernel/acpi/boot.c. ( assume functions mrst.c are copied
> >> from there)
> >>
> >> and should kill print_mp_irq_info or print_MP_intsrc_info...
> > 
> > Nice archaelogical detective work ! :)
> > 
> > So now I have Fengs patch plus Yinghais series which seem to go
> > nicely together, but I have the feeling that there is some stuff
> > unresolved.
> > 
> > Yinghai, Feng: could you please work out the missing bits an pieces
> > (if any) and provide me a delta patch on top of the existing
> > patches?
> > 
> 
> Maybe Feng could send you updated version with simpler function?

Sure, will do.

But I guess Thomas wants more cleanup :) The MP table parsing/ACPI/MRST
have many things in common, like lapic/ioapic setup and IRQ info setting,
so generally there may be some other places where we could simplify codes
by using one copy to cover all three, like what you just did for lapic
registering.

Anyway I will send one updated one for this patch.

Thanks,
Feng


> 
> Yinghai
