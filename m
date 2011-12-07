Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1LGMrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:47:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab1LGMri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:47:38 -0500
Message-ID: <4EDF6049.2030204@redhat.com>
Date: Wed, 07 Dec 2011 14:47:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Raghavendra K T <raghukt@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com> <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com> <20111207104849.GA24849@amt.cnet> <4EDF5413.1030107@linux.vnet.ibm.com> <20111207123330.GA32212@amt.cnet>
In-Reply-To: <20111207123330.GA32212@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 02:33 PM, Marcelo Tosatti wrote:
> > 
> > Also Avi pointed that, logically kvm_arch_vcpu_ioctl_set_mpstate should
> > be called only in vcpu thread, so after further debugging, I noticed
> > that,  setting vcpuN->mp_state = KVM_MP_STATE_RUNNABLE; is not
> > necessary.
> > I 'll remove that in the next patch. Thanks for pointing.
>
> In fact you don't need kvm_arch_vcpu_ioctl_set_mpstate either, only the
> new "kicked" flag.

If we have a kicked flag, it becomes necessary to live migrate it.

Maybe we can change KVM_GET_MP_STATE to fold the kicked flag into the mp
state (converting HALTED into RUNNABLE).

Also I think we can keep the kicked flag in vcpu->requests, no need for
new storage.

-- 
error compiling committee.c: too many arguments to function

