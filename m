Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1ELNGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:06:46 -0400
Received: from 8bytes.org ([88.198.83.132]:57086 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab1ELNGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:06:45 -0400
Date: Thu, 12 May 2011 15:06:44 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
Message-ID: <20110512130644.GF8707@8bytes.org>
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBAD8F.8030006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBAD8F.8030006@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:51:11PM +0300, Avi Kivity wrote:
> On 05/12/2011 12:33 PM, Joerg Roedel wrote:

>> Gaah, I was just about to submit a talk about PMU virtualization for KVM
>> Forum :)
>
> Speed matters.

I'll take that as an argument for paravirt pmu, because that one is
certainly faster than anything we can emulate on-top of perf_events ;-)


> Note, at this time the architectural PMU is only recognized on an Intel  
> host.
>
> Is the statement "if an AMD processor returns non-zero information in  
> cpuid leaf 0xa, then that processor will be compatible with other  
> vendors' processors reporting the same information" correct?

AMD processors don't implement that cpuid leaf.

> If so, we can move the detection of the architectural pmu outside the  
> cpu vendor checks, and this code will work on both AMD and Intel  
> processors (even if the host cpu doesn't have an architectural PMU).

Thats already some kind of paravirtualization. Don't get me wrong, I see
the point of emulating a real pmu in the guest. But on the other side I
think a interface that works across cpu models fits better into the KVM
design, because KVM (oposed to other hypervisors) trys to hide details
of the host cpu as much as necessary to get migration working between
different cpus.
And since pmu are, as you said, very model-specific, some abstraction is
needed. In the end probably both ways can be implemented in parallel:

	* re-implementing the host-pmu using perf_events for -cpu host
	  guests
	* a paravirt pmu for everybody that wants migration and more
	  accurate results

Regards,

	Joerg

