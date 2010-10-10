Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0JJN15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 09:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0JJN14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 09:27:56 -0400
Date: Sun, 10 Oct 2010 15:27:02 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 06/12] Add PV MSR to enable asynchronous page faults
 delivery.
Message-ID: <20101010132702.GP2397@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-7-git-send-email-gleb@redhat.com>
 <4CADC01E.3060409@redhat.com>
 <20101007175329.GF2397@redhat.com>
 <4CB1B5EF.7040207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB1B5EF.7040207@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 02:47:43PM +0200, Avi Kivity wrote:
>  On 10/07/2010 07:53 PM, Gleb Natapov wrote:
> >On Thu, Oct 07, 2010 at 02:42:06PM +0200, Avi Kivity wrote:
> >>   On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> >>  >Guest enables async PF vcpu functionality using this MSR.
> >>  >
> >>  >   			return NON_PRESENT;
> >>  >+
> >>  >+MSR_KVM_ASYNC_PF_EN: 0x4b564d02
> >>  >+	data: Bits 63-6 hold 64-byte aligned physical address of a 32bit memory
> >>
> >>  Given that it must be aligned anyway, we can require it to be a
> >>  64-byte region and also require that the guest zero it before
> >>  writing the MSR.  That will give us a little more flexibility in the
> >>  future.
> >>
> >No code change needed, so OK.
> 
> The guest needs to allocate a 64-byte per-cpu entry instead of a
> 4-byte entry.
> 
Yes, noticed that already :(

> 
> >>  >+
> >>  >+	kvm_async_pf_wakeup_all(vcpu);
> >>
> >>  Why is this needed?  If all apfs are flushed at disable time, what
> >>  do we need to wake up?
> >For migration. Destination will rewrite msr and all processes will be
> >waked up.
> 
> Ok. What happens to apf completions that happen after all vcpus are stopped?
> 
They will be cleaned by kvm_clear_async_pf_completion_queue() on vcpu
destroy.

--
			Gleb.
