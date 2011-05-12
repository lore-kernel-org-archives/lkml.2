Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1ELJve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab1ELJvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:51:32 -0400
Message-ID: <4DCBAD8F.8030006@redhat.com>
Date: Thu, 12 May 2011 12:51:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org>
In-Reply-To: <20110512093309.GD8707@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 12:33 PM, Joerg Roedel wrote:
> On Wed, May 11, 2011 at 11:55:28AM -0400, Avi Kivity wrote:
> >  This not-for-merging patchset exposes an emulated version 1 architectural
> >  performance monitoring unit to KVM guests.  The PMU is emulated using
> >  perf_events, so the host kernel can multiplex host-wide, host-user, and the
> >  guest on available resources.
> >
> >  Caveats:
> >  - counters that have PMI (interrupt) enabled stop counting after the
> >    interrupt is signalled.  This is because we need one-shot samples
> >    that keep counting, which perf doesn't support yet
> >  - some combinations of INV and CMASK are not supported
> >  - counters keep on counting in the host as well as the guest
> >  - the RDPMC instruction and CR4.PCE bit are not yet emulated
> >  - there is likely a bug in the implementation; running 'perf top' in
> >    a guest that spends 80% of its time in userspace shows perf itself
> >    as consuming almost all cpu
> >
> >  perf maintainers: please consider the first three patches for merging (the
> >  first two make sense even without the rest).  If you're familiar with the Intel
> >  PMU, please review patch 5 as well - it effectively undoes all your work
> >  of abstracting the PMU into perf_events by unabstracting perf_events into what
> >  is hoped is a very similar PMU.
>
> Gaah, I was just about to submit a talk about PMU virtualization for KVM
> Forum :)

Speed matters.

> Anyway, I thought about a paravirt-approach instead of implementing a
> real PMU... But there are certainly good reasons for both.

Note, at this time the architectural PMU is only recognized on an Intel 
host.

Is the statement "if an AMD processor returns non-zero information in 
cpuid leaf 0xa, then that processor will be compatible with other 
vendors' processors reporting the same information" correct?

If so, we can move the detection of the architectural pmu outside the 
cpu vendor checks, and this code will work on both AMD and Intel 
processors (even if the host cpu doesn't have an architectural PMU).

-- 
error compiling committee.c: too many arguments to function

