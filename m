Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1LZOXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 09:23:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:43425 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab1LZOXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 09:23:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="50691116"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>, kvm <kvm@vger.kernel.org>,
        "Li, Susie" <susie.li@intel.com>
Subject: RE: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer
 feature in the absence of in-kernel APIC
Thread-Topic: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer
 feature in the absence of in-kernel APIC
Thread-Index: AQHMw8J0EMLo04NprEiFAJB5/AX+ZJXuK93g
Date: Mon, 26 Dec 2011 14:23:39 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335C418@SHSMSX101.ccr.corp.intel.com>
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com>
 <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com>
 <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com>
 <4EF1146D.208@siemens.com> <4EF1B081.3010109@siemens.com>
 <4EF1B423.8050707@siemens.com> <4EF1B67D.7010603@redhat.com>
 <DE8DF0795D48FD4CA783C40EC82923358DEA@SHSMSX101.ccr.corp.intel.com>
 <4EF71919.40201@redhat.com>
 <DE8DF0795D48FD4CA783C40EC8292335BFA0@SHSMSX101.ccr.corp.intel.com>
 <4EF85BF3.9010903@redhat.com>
In-Reply-To: <4EF85BF3.9010903@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 12/26/2011 10:11 AM, Liu, Jinsong wrote:
>>> 
>>> It breaks live migration: if you start a guest on a TSC-deadline
>>> capable host kernel, and migrate it to a TSC-deadline incapable host
>>> kernel, you end up with a broken guest.
>>> 
>>> More broadly, kvm never exposes features transparently to the guest,
>>> it always passes them to userspace first, so userspace controls the
>>> ABI exposed to the guest.  This prevents the following scenario:
>> 
>> Do you mean, by the method qemu control cpuid exposing, it can avoid
>> live migration broken issue by 
>> 1. user probe the lowest ability host of whole pool where vm may
>> live migrate; 
>> 2. only if the lowest ablility host support the feature can user
>> enable the feature when boot a vm; 
>> 3. if the lowest ability host didn't support the feature (say tsc
>> deadline timer as example), user disable the feature when boot a vm;
>> In this way, live migration wouldn't be broken. Right? 
> 
> Right.

Thanks Avi, for your detailed explanation, fix a long misunderstanding I had for live migration.

Best Regards,
Jinsong

> 
>> or, do you mean qemu-kvm solve live migration broken issue by some
>> other method? 
> 
> The method you outlined, or any other method, such as partitioning the
> cluster according to hardware capabilities.
> 
>> 
>>> 
>>> - a guest is started on some hardware, which doesn't support some
>>> cpuid feature (say AVX for example)
>>> - the guest or one of its applications are broken wrt AVX, but
>>> because the feature is not exposed, it works correctly
>>> - the host hardware is upgraded to one which supports AVX
>>> - the guest is now broken
>> 
>> You mean, live migrate from 'old' (which doesn't support the
>> feature) platform to 'new' platform would broken? 
> 
> Live migration, or even just a guest restart on updated hardware.

