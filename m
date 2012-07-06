Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab2GFSMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610Ab2GFSMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:12:46 -0400
Date: Fri, 6 Jul 2012 14:11:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
Message-ID: <20120706171128.GA8835@amt.cnet>
References: <20120619202047.26191.40429.sendpatchset@codeblue>
 <20120619165104.2a4574f8@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619165104.2a4574f8@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 04:51:04PM -0400, Rik van Riel wrote:
> On Wed, 20 Jun 2012 01:50:50 +0530
> Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
> 
> > 
> > In ple handler code, last_boosted_vcpu (lbv) variable is
> > serving as reference point to start when we enter.
> 
> > Also statistical analysis (below) is showing lbv is not very well
> > distributed with current approach.
> 
> You are the second person to spot this bug today (yes, today).
> 
> Due to time zones, the first person has not had a chance yet to
> test the patch below, which might fix the issue...
> 
> Please let me know how it goes.
> 
> ====8<====
> 
> If last_boosted_vcpu == 0, then we fall through all test cases and
> may end up with all VCPUs pouncing on vcpu 0.  With a large enough
> guest, this can result in enormous runqueue lock contention, which
> can prevent vcpu0 from running, leading to a livelock.
> 
> Changing < to <= makes sure we properly handle that case.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Applied, thanks.

