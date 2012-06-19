Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2FSGEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:04:44 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42767 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2FSGEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:04:43 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 1/7] KVM Guest: Add VCPU running/pre-empted state for guest
In-Reply-To: <20120612224310.GC1973@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050547.4560.48709.stgit@abhimanyu.in.ibm.com> <20120612224310.GC1973@amt.cnet>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 19 Jun 2012 11:33:30 +0530
Message-ID: <87d34vsurx.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061819-9264-0000-0000-000001BA745C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012 19:43:10 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Jun 04, 2012 at 10:36:05AM +0530, Nikunj A. Dadhania wrote:
> > The patch adds guest code for msr between guest and hypervisor. The
> > msr will export the vcpu running/pre-empted information to the guest
> > from host. This will enable guest to intelligently send ipi to running
> > vcpus and set flag for pre-empted vcpus. This will prevent waiting for
> > vcpus that are not running.
> > 
> > Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

[...]

> > @@ -433,6 +464,8 @@ void __init kvm_guest_init(void)
> >  		pv_time_ops.steal_clock = kvm_steal_clock;
> >  	}
> >  
> > +	has_vcpu_state = 1;
> > +
> 
> Should be checking for a feature bit, see kvm_para_has_feature() 
> examples above in the function.
>
Sure, will take of this in my next version. 


