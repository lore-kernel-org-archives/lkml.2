Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2I3IRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:17:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2I3IQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:16:57 -0400
Message-ID: <5067FFDF.2050501@redhat.com>
Date: Sun, 30 Sep 2012 10:16:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <5060851E.1030404@redhat.com> <506166B4.4010207@linux.vnet.ibm.com> <5061713D.5060406@redhat.com> <CAJocwcf+8u84_yDC-PK0Yni93YSTWzYvr69nq6b3pNv1MwVJzQ@mail.gmail.com> <50641356.5070008@redhat.com> <50643802.5050200@linux.vnet.ibm.com> <50644148.5090201@redhat.com> <20120928181801.GB17449@localhost.localdomain>
In-Reply-To: <20120928181801.GB17449@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 08:18 PM, Konrad Rzeszutek Wilk wrote:
>> >> PLE:
>> >> - works for unmodified / non-Linux guests
>> >> - works for all types of spins (e.g. smp_call_function*())
>> >> - utilizes an existing hardware interface (PAUSE instruction) so likely
>> >> more robust compared to a software interface
>> >>
>> >> PV:
>> >> - has more information, so it can perform better
>> > 
>> > Should we also consider that we always have an edge here for non-PLE
>> > machine?
>> 
>> True.  The deployment share for these is decreasing rapidly though.  I
>> hate optimizing for obsolete hardware.
> 
> Keep in mind that the patchset that Jeremy provided also cleans (remove)
> parts of the pv spinlock code. It removes the various spin_lock,
> spin_unlock, etc that touch paravirt code. Instead the pv code is only
> in the slowpath. And if you don't compile with CONFIG_PARAVIRT_SPINLOCK
> the end code is the same as it is now.

We still need to maintain information about the lock holder if pv is
enabled at all, even if it is never used.

> On a different subject-  I am curious whether the Haswell new locking
> instructions (the transactional ones?) can be put in usage for the slow
> case?

Transactions are blown on any context switch, so no.

-- 
error compiling committee.c: too many arguments to function
