Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab2GLCUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:20:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:34170 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646Ab2GLCUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:20:01 -0400
Message-ID: <1342059558.18850.48.camel@pasglop>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
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
        Paul Mackerras <paulus@samba.org>
Date: Thu, 12 Jul 2012 12:19:18 +1000
In-Reply-To: <4FFD621D.5090607@redhat.com>
References: <20120709062012.24030.37154.sendpatchset@codeblue>
	 <4FFA8E5E.3070108@de.ibm.com> <4FFD422B.9060008@redhat.com>
	 <4FFD52CD.7040403@de.ibm.com> <4FFD5DA3.3010001@redhat.com>
	 <39DA3B9A-87D6-4EA5-B1FF-B6E30733EF7B@suse.de>
	 <4FFD621D.5090607@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 14:23 +0300, Avi Kivity wrote:
> On 07/11/2012 02:16 PM, Alexander Graf wrote:
> >> 
> >>> yes the data structure itself seems based on the algorithm
> >>> and not on arch specific things. That should work. If we move that to common 
> >>> code then s390 will use that scheme automatically for the cases were we call 
> >>> kvm_vcpu_on_spin(). All others archs as well.
> >> 
> >> ARM doesn't have an instruction for cpu_relax(), so it can't intercept
> >> it.  Given ppc's dislike of overcommit,
> > 
> > What dislike of overcommit?
> 
> I understood ppc virtualization is more of the partitioning sort.
> Perhaps I misunderstood it.  But the reliance on device assignment, the
> restrictions on scheduling, etc. all point to it.

It historically was but that has changed quite a bit. Essentially the
user can configure partitions to be more of the "all virtualized" kind
or on the contrary more fixed partitions. The hypervisor does shared
processors and we have paravirt APIs to cede our time slice to the lock
holder. 

> >> and the way it implements cpu_relax() by adjusting hw thread priority,
> > 
> > Yeah, I don't think we can intercept relaxing.
> 
> ... and the lack of ability to intercept cpu_relax() ...
> 
> > It's basically a nop-like instruction that gives hardware hints on its current priorities.
> 
> That's what x88 PAUSE does.  But we can intercept it (and not just any
> execution - we can restrict intercept to tight loops executed more than
> a specific number of times).
> 
> > That said, we can always add PV code.
> 
> Sure, but that's defeated by advancements like self-tuning PLE exits.
> It's hard to get this right.
> 

Cheers,
Ben.


