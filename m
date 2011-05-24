Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab1EXGDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:03:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1EXGDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:03:39 -0400
Date: Tue, 24 May 2011 08:03:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [GIT PULL] more x86/apic changes for v2.6.40
Message-ID: <20110524060321.GA20904@elte.hu>
References: <20110523193035.GA9170@elte.hu>
 <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 23, 2011 at 12:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest x86-apic-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus
> 
> Hmm. Right now my bisect is going (and on that slow atom thing I'm
> just about to give up for the evening and continue tomorrow), but it
> *looks* like this pull breaks resume on my eeepc netbook.
> 
> I've bisected it down to three merges:
>  - sched-core-for-linus (looks unlikely)
>  - 'for-linus' of master.kernel.org:/home/rmk/linux-2.6-arm
>  - x86-apic-for-linus (I don't see anything wrong, but it seems to be
> the most likely of the three)
> 
> Any idea why anything there would break resume?

Possibly the resume fix in the APIC merge :-/

It's these commits:

 31dce14a3269: x86, ioapic: Use ioapic_saved_data while enabling intr-remapping
 4c79185cdb14: x86, ioapic: Allocate ioapic_saved_data early
 b64ce24daffb: x86, ioapic: Fix potential resume deadlock

The first one fixes the resume bug in an easily backportable way (although the 
GFP_ATOMIC is not nice), the later two do it cleaner.

So if b64ce24daffb works for you and 31dce14a3269 breaks this would signal that 
the fix from Suresh is the source of the Atom regression.

Thanks,

	Ingo
