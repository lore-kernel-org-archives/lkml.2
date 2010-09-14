Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0INKrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 06:47:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0INKrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 06:47:51 -0400
Message-ID: <4C8F52C2.1020606@redhat.com>
Date: Tue, 14 Sep 2010 12:47:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Zachary Amsden <zamsden@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C8F3FF3.9080803@redhat.com> <4C8F5125.5060505@siemens.com>
In-Reply-To: <4C8F5125.5060505@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/14/2010 12:40 PM, Jan Kiszka wrote:
> >>  For yet unknown reason, this commit breaks Linux guests here if they are
> >>  started with only a single VCPU. They hang during boot, obviously no
> >>  longer receiving interrupts.
> >>
> >>  I'm using kvm-kmod against a 2.6.34 host kernel, so this may be a side
> >>  effect of the wrapping, though I cannot imagine how.
> >>
> >>  Anyone any ideas?
> >>
> >>
> >
> >  Most likely, time went backwards, and some 'future - past' calculation
> >  resulted in a negative sleep value which was then interpreted as
> >  unsigned and resulted in a 2342525634 year sleep.
>
> Looks like that's the case on first glance at the apic state.

Aside from this bug, it would be better for the guest to use signed 
arithmetic (or check beforehand) and not sleep if the future is already 
past.

> >
> >  Does your guest use kvmclock, tsc, or some other time source?
>
> A kernel that has kvmclock support even hangs in SMP mode.

Does it have the recent kvmclock patches backported? (should be in 
latest -stable).

> The others
> pick hpet or acpi_pm. TSC is considered unstable.
>
>

Wierd.  But perhaps it's the scheduler clock that's misbehaving, IIRC it 
has its own local clock.

-- 
error compiling committee.c: too many arguments to function

