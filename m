Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1LZLf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:35:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab1LZLfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:35:25 -0500
Message-ID: <4EF85BF3.9010903@redhat.com>
Date: Mon, 26 Dec 2011 13:35:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>, kvm <kvm@vger.kernel.org>,
        "Li, Susie" <susie.li@intel.com>
Subject: Re: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer feature
 in the absence of in-kernel APIC
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com> <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com> <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com> <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com> <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com> <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com> <4EF1146D.208@siemens.com> <4EF1B081.3010109@siemens.com> <4EF1B423.8050707@siemens.com> <4EF1B67D.7010603@redhat.com> <DE8DF0795D48FD4CA783C40EC82923358DEA@SHSMSX101.ccr.corp.intel.com> <4EF71919.40201@redhat.com> <DE8DF0795D48FD4CA783C40EC8292335BFA0@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335BFA0@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2011 10:11 AM, Liu, Jinsong wrote:
> > 
> > It breaks live migration: if you start a guest on a TSC-deadline
> > capable host kernel, and migrate it to a TSC-deadline incapable host
> > kernel, you end up with a broken guest.
> > 
> > More broadly, kvm never exposes features transparently to the guest,
> > it always passes them to userspace first, so userspace controls the
> > ABI exposed to the guest.  This prevents the following scenario:
>
> Do you mean, by the method qemu control cpuid exposing, it can avoid live migration broken issue by
> 1. user probe the lowest ability host of whole pool where vm may live migrate;
> 2. only if the lowest ablility host support the feature can user enable the feature when boot a vm;
> 3. if the lowest ability host didn't support the feature (say tsc deadline timer as example), user disable the feature when boot a vm;
> In this way, live migration wouldn't be broken. Right?

Right.

> or, do you mean qemu-kvm solve live migration broken issue by some other method?

The method you outlined, or any other method, such as partitioning the
cluster according to hardware capabilities.

>
> > 
> > - a guest is started on some hardware, which doesn't support some
> > cpuid feature (say AVX for example)
> > - the guest or one of its applications are broken wrt AVX, but because
> > the feature is not exposed, it works correctly
> > - the host hardware is upgraded to one which supports AVX
> > - the guest is now broken
>
> You mean, live migrate from 'old' (which doesn't support the feature) platform to 'new' platform would broken?

Live migration, or even just a guest restart on updated hardware.

-- 
error compiling committee.c: too many arguments to function

