Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2KTAdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:33:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab2KTAdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:33:19 -0500
Date: Mon, 19 Nov 2012 22:32:58 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] x86: clear vmcss on all cpus when doing kdump if
 necessary
Message-ID: <20121120003258.GA1292@amt.cnet>
References: <50A3645F.60302@cn.fujitsu.com>
 <50A611AA.6030903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50A611AA.6030903@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:12:58PM +0800, zhangyanfei wrote:
> Hello Marcelo,
> 
> Any thoughts?

I thought a function call was OK, but its better to have all code in
vmx.c. Please have an atomic notifier in kexec.c (registered by KVM
module via atomic_notifier_chain_register etc).

Other than that, which is largely cosmetic, it looks fine.
Sorry for not expressing this earlier.


> 于 2012年11月14日 17:29, zhangyanfei 写道:
> > Currently, kdump just makes all the logical processors leave VMX operation by
> > executing VMXOFF instruction, so any VMCSs active on the logical processors may
> > be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
> > in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
> > executing the VMXOFF instruction.
> > 
> > The patch set provides a way to VMCLEAR vmcss related to guests on all cpus before
> > executing the VMXOFF when doing kdump. This is used to ensure the VMCSs in the
> > vmcore updated and non-corrupted.
> > 
> > Changelog from v3 to v4:
> > 1. add a new percpu variable vmclear_skipped to skip
> >    vmclear in kdump in some conditions.
> > 
> > Changelog from v2 to v3:
> > 1. remove unnecessary conditions in function
> >    cpu_emergency_clear_loaded_vmcss as Marcelo suggested.
> > 
> > Changelog from v1 to v2:
> > 1. remove the sysctl and clear VMCSs unconditionally.
> > 
> > Zhang Yanfei (2):
> >   x86/kexec: VMCLEAR vmcss on all cpus if necessary
> >   KVM: set/unset crash_clear_loaded_vmcss and vmclear_skipped in
> >     kvm_intel module
> > 
> >  arch/x86/include/asm/kexec.h |    3 +++ 
> >  arch/x86/kernel/crash.c      |   32 ++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx.c           |   32 ++++++++++++++++++++++++++++++++
> >  3 files changed, 67 insertions(+), 0 deletions(-)
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
