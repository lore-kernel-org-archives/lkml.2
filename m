Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab1CXVne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:43:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:9674 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab1CXVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:43:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,239,1299484800"; 
   d="scan'208";a="901481388"
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86\@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
References: <201103241026.01624.knikanth@suse.de>
	<20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
	<4D8B83DA02000078000381DE@vpn.id2.novell.com>
	<20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
	<1300999682.2714.23.camel@edumazet-laptop>
	<20110324205422.GB2393@elte.hu>
	<1301000557.2714.33.camel@edumazet-laptop>
Date: Thu, 24 Mar 2011 14:42:07 -0700
In-Reply-To: <1301000557.2714.33.camel@edumazet-laptop> (Eric Dumazet's
	message of "Thu, 24 Mar 2011 22:02:37 +0100")
Message-ID: <m2oc50kxg0.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:
>
> [    0.015998] Performance Events: PEBS fmt0+, Core2 events, Broken BIOS detected, using software events only.
> [    0.015998] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 186 is 43003c)

There should be a BIOS setting to disable that (something with p-states
likely).

> I am pretty sure I used "-e ..." some time ago with same BIOS.

The "if anyone else uses the PMU throw in your toys and sulk" check was
only recently added.

Or fix perf just ignore counters that are already used. The others
should work fine.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
