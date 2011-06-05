Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1FEIMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab1FEIMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:12:38 -0400
Message-ID: <4DEB3A62.9040105@redhat.com>
Date: Sun, 05 Jun 2011 11:12:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to guests
References: <1305129333-7456-1-git-send-email-avi@redhat.com>	 <1305129333-7456-6-git-send-email-avi@redhat.com> <1307112111.2353.3390.camel@twins>
In-Reply-To: <1307112111.2353.3390.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 05:41 PM, Peter Zijlstra wrote:
> On Wed, 2011-05-11 at 11:55 -0400, Avi Kivity wrote:
> >  - counters that have PMI (interrupt) enabled stop counting after the
> >    interrupt is signalled.  This is because we need one-shot samples
> >    that keep counting, which perf doesn't support yet
>
> You'll have to reprogram the thing anyway, since not all hardware has
> the same counter width:
>
> [    0.046996] Performance Events: AMD PMU driver.
> [    0.048998] ... bit width:              48
>
> vs
>
> [    0.026998] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
> [    0.026998] ... bit width:              40
>
> simply letting the thing run will not behave in a consistent fashion.

I don't really follow.  How is the bit width related?

We adjust for bit width during PMC read.

Though I agree for accurate emulation we do need to reprogram, so we can 
set the next overflow event at 2^bit_width.  I doubt that anyone relies 
on this second overflow (even with 40 bits counting cycles, it takes far 
too long to overflow), still we have to emulate it.

> Or are you going to assume all software will properly read the cpuid
> leaf and not assume bit width?
>
> Also, I can't seem to locate where you fill that cpuid-leaf,
> kvm_pmu_cpuid_update() seems to read the entry, not write it.

We rely on host userspace to set up cpuid (and KVM_GET_SUPPORTED_CPUID 
to report to userspace what we support).

-- 
error compiling committee.c: too many arguments to function

