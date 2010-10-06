Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab0JFK4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:56:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab0JFK4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:56:00 -0400
Date: Wed, 6 Oct 2010 12:55:04 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
        cl@linux-foundation.org
Subject: Re: [PATCH v6 07/12] Add async PF initialization to PV guest.
Message-ID: <20101006105504.GV11145@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-8-git-send-email-gleb@redhat.com>
 <20101005182554.GA1786@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005182554.GA1786@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 03:25:54PM -0300, Marcelo Tosatti wrote:
> On Mon, Oct 04, 2010 at 05:56:29PM +0200, Gleb Natapov wrote:
> > Enable async PF in a guest if async PF capability is discovered.
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > ---
> >  Documentation/kernel-parameters.txt |    3 +
> >  arch/x86/include/asm/kvm_para.h     |    5 ++
> >  arch/x86/kernel/kvm.c               |   92 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 100 insertions(+), 0 deletions(-)
> > 
> 
> > +static int __cpuinit kvm_cpu_notify(struct notifier_block *self,
> > +				    unsigned long action, void *hcpu)
> > +{
> > +	int cpu = (unsigned long)hcpu;
> > +	switch (action) {
> > +	case CPU_ONLINE:
> > +	case CPU_DOWN_FAILED:
> > +	case CPU_ONLINE_FROZEN:
> > +		smp_call_function_single(cpu, kvm_guest_cpu_notify, NULL, 0);
> 
> wait parameter should probably be 1.
Why should we wait for it? FWIW I copied this from somewhere (May be
arch/x86/pci/amd_bus.c).

--
			Gleb.
