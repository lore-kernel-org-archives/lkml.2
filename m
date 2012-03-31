Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab2CaEKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 00:10:07 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:40959 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2CaEKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 00:10:01 -0400
Date: Sat, 31 Mar 2012 09:39:15 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
Message-ID: <20120331040915.GF13345@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
 <4F7616F5.4070000@zytor.com>
 <alpine.LFD.2.02.1203302333560.2542@ionos>
 <20120331040745.GC14030@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120331040745.GC14030@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12033018-6102-0000-0000-0000012529DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2012-03-31 09:37:45]:

> The issue is with ticketlocks though. VCPUs could go into a spin w/o
> a lock being held by anybody. Say VCPUs 1-99 try to grab a lock in
> that order (on a host with one cpu). VCPU1 wins (after VCPU0 releases it)
> and releases the lock. VCPU1 is next eligible to take the lock. If 

Sorry I meant to say "VCPU2 is next eligible ..."

> that is not scheduled early enough by host, then remaining vcpus would keep 
> spinning (even though lock is technically not held by anybody) w/o making 
> forward progress.
> 
> In that situation, what we really need is for the guest to hint to host
> scheduler to schedule VCPU1 early (via yield_to or something similar). 

s/VCPU1/VCPU2 ..

- vatsa

