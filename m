Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1JSJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 05:27:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab1JSJ1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 05:27:15 -0400
Message-ID: <4E9E97D2.1040807@redhat.com>
Date: Wed, 19 Oct 2011 11:26:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Alex,Shi" <alex.shi@intel.com>
CC: Christoph Lameter <cl@gentwo.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>, tglx@linutronix.de,
        mingo@redhat.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        davem@davemloft.net, kaber@trash.net, a.p.zijlstra@chello.nl,
        kvm@vger.kernel.org, jeremy@xensource.com
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
References: <1318237851.27949.190.camel@debian>  <alpine.DEB.2.00.1110101026080.16264@router.home>  <1318324774.27949.693.camel@debian>  <alpine.DEB.2.00.1110110910480.3388@router.home>  <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>  <alpine.DEB.2.00.1110120910540.26610@router.home>  <1318908091.23426.52.camel@debian>  <alpine.DEB.2.00.1110180932330.687@router.home> <1319016218.23426.104.camel@debian>
In-Reply-To: <1319016218.23426.104.camel@debian>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2011 11:23 AM, Alex,Shi wrote:
> > Well do the obvious (where you can see that interrupts or preemption are
> > disabled in the function or in a calling function). Leave the rest as is
> > and provide separate patches for them?
>
> Thanks for comments! I initialized the patch as following accordingly,
> And cc to more maintainers for review. I checked all code except xen/kvm
> part, totally a idiot for them. 
>
>
>
> ==========
>
> Since percpu_xxx() serial functions are duplicate with this_cpu_xxx().
> Removing percpu_xxx() definition and replacing them by this_cpu_xxx() in
> code.
>
> And further more, as Christoph Lameter's requirement, I try to use
> __this_cpu_xx to replace this_cpu_xxx if it is in preempt safe scenario.
> The preempt safe scenarios include:
> 1, in irq/softirq/nmi handler
> 2, protected by preempt_disable
> 3, protected by spin_lock
> 4, if the code context imply that it is preempt safe, like the code is
> follows or be followed a preempt safe code.
>
> I left the xen/kvm part code unchanged, since no any idea of them.
>
>

All of the kvm usage is in preemption disabled contexts.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

