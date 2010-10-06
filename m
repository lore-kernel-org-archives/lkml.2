Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab0JFUFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:05:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45243 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574Ab0JFUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:05:40 -0400
Date: Wed, 6 Oct 2010 22:05:20 +0200
From: Gleb Natapov <gleb@minantech.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, hpa@zytor.com,
        riel@redhat.com, cl@linux-foundation.org
Subject: Re: [PATCH v6 07/12] Add async PF initialization to PV guest.
Message-ID: <20101006200520.GB4120@minantech.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-8-git-send-email-gleb@redhat.com>
 <20101005182554.GA1786@amt.cnet>
 <20101006105504.GV11145@redhat.com>
 <20101006144512.GC31423@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006144512.GC31423@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 11:45:12AM -0300, Marcelo Tosatti wrote:
> On Wed, Oct 06, 2010 at 12:55:04PM +0200, Gleb Natapov wrote:
> > On Tue, Oct 05, 2010 at 03:25:54PM -0300, Marcelo Tosatti wrote:
> > > On Mon, Oct 04, 2010 at 05:56:29PM +0200, Gleb Natapov wrote:
> > > > Enable async PF in a guest if async PF capability is discovered.
> > > > 
> > > > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > > > ---
> > > >  Documentation/kernel-parameters.txt |    3 +
> > > >  arch/x86/include/asm/kvm_para.h     |    5 ++
> > > >  arch/x86/kernel/kvm.c               |   92 +++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 100 insertions(+), 0 deletions(-)
> > > > 
> > > 
> > > > +static int __cpuinit kvm_cpu_notify(struct notifier_block *self,
> > > > +				    unsigned long action, void *hcpu)
> > > > +{
> > > > +	int cpu = (unsigned long)hcpu;
> > > > +	switch (action) {
> > > > +	case CPU_ONLINE:
> > > > +	case CPU_DOWN_FAILED:
> > > > +	case CPU_ONLINE_FROZEN:
> > > > +		smp_call_function_single(cpu, kvm_guest_cpu_notify, NULL, 0);
> > > 
> > > wait parameter should probably be 1.
> > Why should we wait for it? FWIW I copied this from somewhere (May be
> > arch/x86/pci/amd_bus.c).
> 
> So that you know its executed in a defined point in cpu bringup.
> 
If I read code correctly CPU we are notified about is already running when
callback is called, so I do not see what waiting for IPI to be processed will
accomplish here. With many cpus we will make boot a little bit slower. I don't
care too much though, so if you still think that 1 is required here I'll make
it so. 

--
			Gleb.
