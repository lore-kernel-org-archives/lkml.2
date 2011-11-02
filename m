Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1KBBWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 21:22:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50467 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1KBBWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 21:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <CABeCy1aFW7z+-s2m-Fx6Fhcj7Dpa3Mm5hEh7fPiD3_CxFdQbPA@mail.gmail.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	<CAGjg+kH577VE4cyq5zVNR962S6xbGCNnGS0w6N1DVuOppL3Khw@mail.gmail.com>
	<CABeCy1Y_OXPJkca6dRvK4-PCfKH8wD_2Aq-9r-JyBBSCetrsOw@mail.gmail.com>
	<CAGjg+kFyqWa=Ui+XRDoCvYFLt7eH-vScFk24tk1aZJkfWRMOxQ@mail.gmail.com>
	<CABeCy1aFW7z+-s2m-Fx6Fhcj7Dpa3Mm5hEh7fPiD3_CxFdQbPA@mail.gmail.com>
Date: Wed, 2 Nov 2011 09:22:41 +0800
Message-ID: <CAGjg+kHMc1r2bFKeSvW3UOw6xELsevT2VZpEpQ111TbAYMU91g@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: alex shi <lkml.alex@gmail.com>
To: Venki Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I tested the patch against 3.1 kernel for specpower benchmark on our
>> machine, westmere core laptop Thinkpad t410(internal name lkp-t410),
>> and on Romely-EP machine(lkp-sb03). No clear power or performance
>> change found. the performance and power has no clear change for every
>> level system load. from 0 to 100%.
>
> Thanks Alex for testing this. Likely that with specpower there are not
> many active timers. Was the run with run level 5 and with all the system daemons
> that come with distro active?
>

The testing run under level 3, without X system. and there really has
no many daemons.
Following is the LOC record on the westmere laptop, before and after
testing. testing costs 4368'.

LOC:      22850      24984      60558      61003   Local timer interrupts
---
LOC:    2773346    2772016    2623716    2644598   Local timer interrupts

There are about 65 interrupts per second on each of cpu. Yes it is not
too much.

Without your patch, the timer interrupts number as following:
LOC:      10564      11942      11758      13075   Local timer interrupts
---
LOC:    2805402    2800421    2671229    2663266   Local timer interrupts

As to X system timers, I didn't find much timers on my working
desktop, the LOC change just a little during 120'. That is i7, Ubuntu,
without default daemons and running many APPs like, evolution/firefox
etc etc.

LOC:        125        114         97         80         63  110108127
  77084851   77289464   Local timer interrupts
--
LOC:        125        114         97         80         63  110112467
  77087975   77294653   Local timer interrupts

So, guess, X system is not good candidate to show the patch effect.
Any others benchmarks recommend?
