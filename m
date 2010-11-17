Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab0KQXV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:21:28 -0500
Received: from smtp-out-213.synserver.de ([212.40.180.213]:1067 "HELO
	smtp-out-213.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750804Ab0KQXV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:21:27 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 12539
Date: Thu, 18 Nov 2010 00:21:20 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101117232120.GA1575@arch.trippelsdorf.de>
References: <20101029172631.GA23546@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011011904280.2566@localhost6.localdomain6>
 <20101101184512.GA1589@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011021626160.9357@localhost6.localdomain6>
 <20101105160919.GC25704@aftab>
 <20101105164225.GA1594@arch.trippelsdorf.de>
 <20101105212749.GA1559@arch.trippelsdorf.de>
 <20101105213248.GB28493@aftab>
 <alpine.LFD.2.00.1011091500220.2900@localhost6.localdomain6>
 <20101109143941.GA31121@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109143941.GA31121@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.11.09 at 15:39 +0100, Borislav Petkov wrote:
> On Tue, Nov 09, 2010 at 09:02:13AM -0500, Thomas Gleixner wrote:
> > > actually your board is not what concerns me, 20 ticks is still ok, more
> > > or less, but there are other machines which contain absurd values in
> > > there like 0x37ee or 0x1000 (a Broadcom chipset). We'll need to give a
> > > change like that a good run before we can be absolutely sure it doesn't
> > > break any machines.
> > 
> > If the ACPI entry is known to be flaky, shouldn't we simply err out on
> > the safe side and use 128 ticks in any case, which is not a really big
> > deal.
> 
> Yep, this is what my proposed fix does. I set it by default to 0x80 and
> the hpet detection code in acpi_parse_hpet() overrides it if it is less
> than that (and obviously a sensible value written by the BIOS).
> 
> Otherwise it issues a warning. Come to think of it, we shouldn't be
> issuing a warning because this'll scream on a very high number of
> systems, IMHO, especially older boards. Instead, we should issue it in
> dmesg during boot just in case.
> 
> The other concern I have is whether min tick of 128 would work for _all_
> possible HPET implementations - I don't know whether there are some very
> b0rked incarnations which delay HPET accesses to more than 128 cycles.
> Kinda hard to say.
> 
> So, to be more specific, here's what I have in mind:

Any update on this issue?

Borislav's patch solves the mysterious "slowdown" problem and is running
without problems for the last two weeks here. 

(And rc2 is already out. So maybe it's time to push this to Linus so
that more people have a chance to test it?)
-- 
Markus
