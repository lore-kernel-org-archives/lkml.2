Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab2I1R7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:59:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43971 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab2I1R7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:59:42 -0400
Date: Fri, 28 Sep 2012 14:18:02 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
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
Message-ID: <20120928181801.GB17449@localhost.localdomain>
References: <505C654B.2050106@redhat.com>
 <505CA2EB.7050403@linux.vnet.ibm.com>
 <50607F1F.2040704@redhat.com>
 <5060851E.1030404@redhat.com>
 <506166B4.4010207@linux.vnet.ibm.com>
 <5061713D.5060406@redhat.com>
 <CAJocwcf+8u84_yDC-PK0Yni93YSTWzYvr69nq6b3pNv1MwVJzQ@mail.gmail.com>
 <50641356.5070008@redhat.com>
 <50643802.5050200@linux.vnet.ibm.com>
 <50644148.5090201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50644148.5090201@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> PLE:
> >> - works for unmodified / non-Linux guests
> >> - works for all types of spins (e.g. smp_call_function*())
> >> - utilizes an existing hardware interface (PAUSE instruction) so likely
> >> more robust compared to a software interface
> >>
> >> PV:
> >> - has more information, so it can perform better
> > 
> > Should we also consider that we always have an edge here for non-PLE
> > machine?
> 
> True.  The deployment share for these is decreasing rapidly though.  I
> hate optimizing for obsolete hardware.

Keep in mind that the patchset that Jeremy provided also cleans (remove)
parts of the pv spinlock code. It removes the various spin_lock,
spin_unlock, etc that touch paravirt code. Instead the pv code is only
in the slowpath. And if you don't compile with CONFIG_PARAVIRT_SPINLOCK
the end code is the same as it is now.

On a different subject-  I am curious whether the Haswell new locking
instructions (the transactional ones?) can be put in usage for the slow
case?
