Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2GIOhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:37:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2GIOhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:03 -0400
Date: Mon, 9 Jul 2012 17:36:58 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
Message-ID: <20120709143658.GD7298@redhat.com>
References: <4FFAE6D8.5050609@gmail.com>
 <20120709141904.GC7298@redhat.com>
 <1341843844.3462.75.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341843844.3462.75.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 04:24:04PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-07-09 at 17:19 +0300, Gleb Natapov wrote:
> > Yes, this is knows problem that I can't find time to fix. The crash is
> > cause by CPU using host PEBS virtual address while guest is running
> > which causes guest memory corruption. We should disable evens that use
> > PEBS at the guest entry. 
> 
> Whoops.. so the hardware is reading the DS address as programmed by the
> host (host linear address) and using it as a guest linear address?
> 
Yes.

> Quality stuff..
DS area and vitalization are definitely not friends.

> 
> Disabling PEBS events for guests isn't pretty though.. but I guess the
> only alternative is mapping the DS into the guest and reprogramming
> MSR_IA32_DS_AREA which is all a little involved I suppose?
This needs guest cooperation which is possible with PV guest of course,
but there is a security issue here. Intel SDM requires that DS have to
be mapped by page table at all time and marked dirty/accessed otherwise
unspecified bad things can happen. Nothing prevents guest from unmapping
DS and cause host troubles.

--
			Gleb.
