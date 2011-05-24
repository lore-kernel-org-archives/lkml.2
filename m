Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1EXGPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:15:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49149 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab1EXGPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:15:36 -0400
Date: Tue, 24 May 2011 08:15:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [GIT PULL] more x86/apic changes for v2.6.40
Message-ID: <20110524061525.GA29815@elte.hu>
References: <20110523193035.GA9170@elte.hu>
 <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
 <20110524060321.GA20904@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524060321.GA20904@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Possibly the resume fix in the APIC merge :-/
> 
> It's these commits:
> 
>  31dce14a3269: x86, ioapic: Use ioapic_saved_data while enabling intr-remapping
>  4c79185cdb14: x86, ioapic: Allocate ioapic_saved_data early
>  b64ce24daffb: x86, ioapic: Fix potential resume deadlock
> 
> The first one fixes the resume bug in an easily backportable way (although 
> the GFP_ATOMIC is not nice), the later two do it cleaner.
> 
> So if b64ce24daffb works for you and 31dce14a3269 breaks this would signal 
> that the fix from Suresh is the source of the Atom regression.

In particular the lapic_resume() bit looks suspect. Does save_ioapic_entries() 
get called? It's called in enable_IR_x2apic() but your Atom is probably not 
x2apic. Non-x2apic system do not get save_ioapic_entries() called, so there's 
nothing to restore at resume time AFAICS ... Suresh?

Thanks,

	Ingo
