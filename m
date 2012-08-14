Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2HNJPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:15:09 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49918 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383Ab2HNJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:15:08 -0400
Date: Tue, 14 Aug 2012 11:15:06 +0200
From: Florian Westphal <fw@strlen.de>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, kvm@vger.kernel.org, avi@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: disable stealtime via reboot notifier to avoid
 mem corruption
Message-ID: <20120814091506.GA13610@breakpoint.cc>
References: <1344594982-8516-1-git-send-email-fw@strlen.de>
 <20120813215231.GA19294@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813215231.GA19294@amt.cnet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Fri, Aug 10, 2012 at 12:36:22PM +0200, Florian Westphal wrote:
> > --- a/arch/x86/kernel/kvmclock.c
> > +++ b/arch/x86/kernel/kvmclock.c
> > @@ -191,7 +191,6 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
> >  static void kvm_shutdown(void)
> >  {
> >  	native_write_msr(msr_kvm_system_time, 0, 0);
> > -	kvm_disable_steal_time();
> >  	native_machine_shutdown();
> >  }
> This part below will introduce a bug for shutdown. Can you retest with
> the addition of kvm_disable_steal_time to kvm_pv_guest_cpu_reboot only,
> retest and resend please?

I can, but the problem with kvm_disable_steal_time() in
kvmclock.c is that with CONFIG_KVM_CLOCK=n the entire
file won't be compiled.

And steal time doesn't depend on CONFIG_KVM_CLOCK=y.
So if removing it there is a bug leaving it in only avoids
that bug for CONFIG_KVM_CLOCK=y.


