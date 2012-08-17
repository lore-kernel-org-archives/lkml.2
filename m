Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab2HQNtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:49:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32953 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab2HQNtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:49:35 -0400
Date: Fri, 17 Aug 2012 14:48:57 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120817134857.GI24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
 <502E11B6.4020104@ti.com>
 <20120817100533.GE24389@arm.com>
 <CAMQu2gzz0j+SnxCY0u3H__H4U-Lor_xV-eyiMBSohCMngbkD2w@mail.gmail.com>
 <20120817131358.GF11011@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817131358.GF11011@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 02:13:59PM +0100, Tony Lindgren wrote:
> * Shilimkar, Santosh <santosh.shilimkar@ti.com> [120817 03:11]:
> > On Fri, Aug 17, 2012 at 3:35 PM, Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > >
> > > On Fri, Aug 17, 2012 at 10:41:10AM +0100, Santosh Shilimkar wrote:
> > > >
> > > > So you expect all the secondary CPUs to be in wakeup state and probably
> > > > looping in WFE for a signal from kernel to boot. There is one issue
> > > > with this requirement though. For large CPU system, you need to reset
> > > > all the CPUs and hit this waiting loop. This will lead to large inrush
> > > > current need at bootup which may be not be supported. To avoid this
> > > > issue, secondary CPUs are kept in OFF state and then they are woken
> > > > up from kernel one by one whenever they need to be brought into the
> > > > system. This requirement should be considered.
> > >
> > > I agree, this part will be extended. That's one method that we currently
> > > support and suitable to the model.
> > >
> > > The better method is the SMC standardisation that Charles Garcia-Tobin
> > > has written (to be made available soon) and was presented at the last
> > > Linaro Connect in HK. Given that the CPU power is usually controlled by
> > > the secure side, we'll ask for an SMC to be issued for waking up
> > > secondary CPUs, so it's up to the secure firmware to write the correct
> > > hardware registers.
> > >
> > Thanks for the information. SMC standardization would indeed help
> > to overcome some of these. Will wait for that information before
> > next set of questions.
> 
> Yes please. If the SMC is not standardized for most calls at least,
> we'll end up with a horrible mess of SoC specific calls like we
> currently have. Related to that, the virtualization calls should be
> also standardized so we don't end up with multiple different hypervisors
> with different calls.

For hypervisor, there are two kinds of API - one meant for power
management that is pretty much the same as the SMC and another specific
to the hypervisor solution (KVM, Xen etc.). The latter is specific to
the host kernel that's running as we start it at EL2 but it's not
standardised. It would be good indeed and there are other advantages
like self-virtualisation but it needs the KVM and Xen guys to come to a
common definition.

-- 
Catalin
