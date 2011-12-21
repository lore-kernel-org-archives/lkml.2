Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1LUKpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:45:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1LUKpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:45:00 -0500
Message-ID: <4EF1B8A4.2050008@redhat.com>
Date: Wed, 21 Dec 2011 12:44:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer feature
 in the absence of in-kernel APIC
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com> <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com> <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com> <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com> <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com> <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com> <4EF1146D.208@siemens.com> <4EF1B081.3010109@siemens.com> <4EF1B423.8050707@siemens.com> <4EF1B67D.7010603@redhat.com> <4EF1B7C0.3080200@siemens.com>
In-Reply-To: <4EF1B7C0.3080200@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 12:41 PM, Jan Kiszka wrote:
> On 2011-12-21 11:35, Avi Kivity wrote:
> > On 12/21/2011 12:25 PM, Jan Kiszka wrote:
> >> We must not report the TSC deadline timer feature on our own when user
> >> space provides the APIC as we have no clue about its features.
> > 
> > We must not report the TSC deadline timer feature on our own, period. 
> > We should just update the timer mode mask there.  Don't know how this
> > slipped through review.
> >
> > I think your original idea was correct.  Add a new KVM_CAP for the tsc
> > deadline timer.  Userspace can add the bit to cpuid if either it
> > implements the feature in a userspace apic, or if it finds the new
> > capability and uses the kernel apic.
>
> Right, we do need some control for user space to keep the feature
> disabled when migrating from an older host.
>
> However, there is also the timer_mode_mask which requires tuning in
> addition to the cpuid flag.
>

timer_mode_mask can just be slaved to the bit (as received by
KVM_SET_CPUID); that's exactly kvm_update_cpuid()'s role.

-- 
error compiling committee.c: too many arguments to function

