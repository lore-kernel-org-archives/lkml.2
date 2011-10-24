Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab1JXNKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:10:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab1JXNK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:10:27 -0400
Message-ID: <4EA56385.9040302@redhat.com>
Date: Mon, 24 Oct 2011 15:09:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
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
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com> <4EA53A7D.300@redhat.com> <20111024122734.GA10634@linux.vnet.ibm.com>
In-Reply-To: <20111024122734.GA10634@linux.vnet.ibm.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 02:27 PM, Srivatsa Vaddagiri wrote:
> Good point. Assuming yield_on_hlt=1, that would allow the vcpu to be put
> to sleep and let other vcpus make progress.
>
> I guess with that change, we can also dropthe need for other hypercall
> introduced in this patch (kvm_pv_kick_cpu_op()). Essentially a vcpu sleeping 
> because of HLT instruction can be woken up by a IPI issued by vcpu releasing a
> lock.

Not if interrupts are disabled.  My original plan was to use NMIs for
wakeups, but it turns out NMIs can be coalesced under certain rare
circumstances; this requires workarounds by the generic NMI code that
make NMIs too slow.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

