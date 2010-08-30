Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0H3RZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:25:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59414 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab0H3RZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:25:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Bug #16173] After uncompressing the kernel, at boot time, the server hangs.
Date: Mon, 30 Aug 2010 19:24:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David Hill" <hilld@binarystorm.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <201008300128.34970.rjw@sisk.pl> <m1wrr9asjx.fsf@fess.ebiederm.org>
In-Reply-To: <m1wrr9asjx.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301924.06603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 30, 2010, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Monday, August 30, 2010, Eric W. Biederman wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >> > This message has been generated automatically as a part of a report
> >> > of regressions introduced between 2.6.34 and 2.6.35.
> >> >
> >> > The following bug entry is on the current list of known regressions
> >> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> >> > be listed and let the tracking team know (either way).
> >> >
> >> 
> >> Looks like it's fixed.
> >
> > Good.  What mainlne commit is that?
> 
> commit 910081322bf9c4ed392dc8f2ecbc33fdb42a2958
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Wed Aug 4 12:51:11 2010 -0700
> 
>     x86/apic: Map the local apic when parsing the MP table.
>     
>     This fixes a regression in 2.6.35 from 2.6.34, that is
>     present for select models of Intel cpus when people are
>     using an MP table.
>     
>     The commit cf7500c0ea133d66f8449d86392d83f840102632
>     "x86, ioapic: In mpparse use mp_register_ioapic" started
>     calling mp_register_ioapic from MP_ioapic_info.  An extremely
>     simple change that was obviously correct.  Unfortunately
>     mp_register_ioapic did just a little more than the previous
>     hand crafted code and so we gained this call path.
>     
>     The problem call path is:
>     MP_ioapic_info()
>       mp_register_ioapic()
>        io_apic_unique_id()
>          io_apic_get_unique_id()
>            get_physical_broadcast()
>              modern_apic()
>                lapic_get_version()
>                  apic_read(APIC_LVR)
>     
>     Which turned out to be a problem because the local apic
>     was not mapped, at that point, unlike the similar point
>     in the ACPI parsing code.
>     
>     This problem is fixed by mapping the local apic when
>     parsing the mptable as soon as we reasonably can.
>     
>     Looking at the number of places we setup the fixmap for
>     the local apic, I see some serious simplification opportunities.
>     For the moment except for not duplicating the setting up of the
>     fixmap in init_apic_mappings, I have not acted on them.
>     
>     The regression from 2.6.34 is tracked in bug
>     https://bugzilla.kernel.org/show_bug.cgi?id=16173
>     
>     Cc: stable@kernel.org
>     Reported-by: David Hill <hilld@binarystorm.net>
>     Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
>     Tested-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
>     Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Thanks, closed.

Rafael
