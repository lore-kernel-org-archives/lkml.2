Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab2GLL04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 07:26:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:40567 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933667Ab2GLL0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 07:26:54 -0400
Message-ID: <1342092250.15597.1.camel@pasglop>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Avi Kivity <avi@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>
Date: Thu, 12 Jul 2012 21:24:10 +1000
In-Reply-To: <4FFE86EC.7090001@redhat.com>
References: <20120709062012.24030.37154.sendpatchset@codeblue>
	 <4FFA8E5E.3070108@de.ibm.com> <4FFD422B.9060008@redhat.com>
	 <4FFD52CD.7040403@de.ibm.com> <4FFD5DA3.3010001@redhat.com>
	 <1342059459.18850.46.camel@pasglop> <4FFE86EC.7090001@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 11:12 +0300, Avi Kivity wrote:
> On 07/12/2012 05:17 AM, Benjamin Herrenschmidt wrote:
> >> ARM doesn't have an instruction for cpu_relax(), so it can't intercept
> >> it.  Given ppc's dislike of overcommit, and the way it implements
> >> cpu_relax() by adjusting hw thread priority, I'm guessing it doesn't
> >> intercept those either, but I'm copying the ppc people in case I'm
> >> wrong.  So it's s390 and x86.
> > 
> > No but our spinlocks call __spin_yield()  (or __rw_yield) which does
> > some paravirt tricks already.
> > 
> > We check if the holder is currently running, and if not, we call the
> > H_CONFER hypercall which can be used to "give" our time slice to the
> > holder.
> > 
> > Our implementation of H_CONFER in KVM is currently a nop though.
> 
> Okay, so you can join the party.  See yield_to() and kvm_vcpu_on_spin().

Thanks ! I'll have a look eventually :-)

Cheers,
Ben.


