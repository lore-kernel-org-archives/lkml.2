Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1JZUJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:09:50 -0400
Received: from claw.goop.org ([74.207.240.146]:48988 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1JZUJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:09:49 -0400
Message-ID: <4EA8690C.1040209@goop.org>
Date: Wed, 26 Oct 2011 13:09:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Raghavendra K T <raghukt@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen <xen-devel@lists.xensource.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to support
 pv-ticketlock
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com> <4EA53A7D.300@redhat.com> <20111024122734.GA10634@linux.vnet.ibm.com> <4EA56385.9040302@redhat.com> <20111024135032.GB10634@linux.vnet.ibm.com> <4EA6FEC2.1060209@linux.vnet.ibm.com> <4EA7E21B.8020805@redhat.com>
In-Reply-To: <4EA7E21B.8020805@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 03:34 AM, Avi Kivity wrote:
> On 10/25/2011 08:24 PM, Raghavendra K T wrote:
>> So then do also you foresee the need for directed yield at some point,
>> to address LHP? provided we have good improvements to prove.
> Doesn't this patchset completely eliminate lock holder preemption?

Well, there's the question of whether its better for someone waiting for
a contended lock to just go to sleep and rely on the scheduler to give
CPU time to whoever currently has the lock, or if the scheduler needs a
little hint to boost the lock holder by giving it the waiter's timeslice.

I tend to prefer the former, since there's no reason to suppose that the
the lock holder vcpu is necessarily the scheduler's top priority, and it
may want to schedule something else anyway.

    J
