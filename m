Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab2EAD0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 23:26:05 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51807 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2EAD0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 23:26:02 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, jeremy@goop.org, mtosatti@redhat.com,
        kvm@vger.kernel.org, x86@kernel.org, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, avi@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v1 1/5] KVM Guest: Add VCPU running/pre-empted state for guest
In-Reply-To: <4F9F367F.8090603@linux.vnet.ibm.com>
References: <20120427161727.27082.43096.stgit@abhimanyu> <20120427162314.27082.13703.stgit@abhimanyu> <4F9F367F.8090603@linux.vnet.ibm.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 01 May 2012 08:55:20 +0530
Message-ID: <87y5pch9b3.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12043017-9264-0000-0000-0000015DE2E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2012 06:33:59 +0530, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
> On 04/27/2012 09:53 PM, Nikunj A. Dadhania wrote:
> > The patch adds guest code for msr between guest and hypervisor. The
> > msr will export the vcpu running/pre-empted information to the guest
> > from host. This will enable guest to intelligently send ipi to running
> > vcpus and set flag for pre-empted vcpus. This will prevent waiting for
> > vcpus that are not running.
> >
> > Suggested-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
> > Signed-off-by: Nikunj A. Dadhania<nikunj@linux.vnet.ibm.com>
> > ---
> >   arch/x86/include/asm/kvm_para.h |   10 ++++++++++
> >   arch/x86/kernel/kvm.c           |   33 +++++++++++++++++++++++++++++++++
> >   2 files changed, 43 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> > index 77266d3..f57b5cc 100644
> > --- a/arch/x86/include/asm/kvm_para.h
> > +++ b/arch/x86/include/asm/kvm_para.h
> > @@ -24,6 +24,7 @@
> >   #define KVM_FEATURE_ASYNC_PF		4
> >   #define KVM_FEATURE_STEAL_TIME		5
> >   #define KVM_FEATURE_PV_UNHALT		6
> > +#define KVM_FEATURE_VCPU_STATE          7
> 
> I think you intended to use KVM_FEATURE_VCPU_STATE to address
> guest/host compatibility issue so that host/guest does not break
> when one of them run older kernel?
>
Yes, thats correct. 

Regards
Nikunj

