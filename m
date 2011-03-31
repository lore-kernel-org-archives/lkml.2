Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab1CaG4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:56:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46515 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab1CaG4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:56:40 -0400
Date: Thu, 31 Mar 2011 08:56:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] x86 idle APM: delete apm_cpu_idle(), and its use of
 pm_idle
Message-ID: <20110331065622.GE5938@elte.hu>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au>
 <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz>
 <20110329004438.d9e755ef.sfr@canb.auug.org.au>
 <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz>
 <20110328174542.GW21838@one.firstfloor.org>
 <4D90CC0B.8070105@zytor.com>
 <20110328182123.GX21838@one.firstfloor.org>
 <AANLkTimqE2YZCH5GonnqeHGGBwzggTymauS1KYuTsqOX@mail.gmail.com>
 <alpine.LNX.2.00.1103282309290.26754@pobox.suse.cz>
 <alpine.LFD.2.02.1103302311500.2444@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103302311500.2444@x980>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> There is some doubt whether the APM idle feature
> to call into the BIOS from the idle loop is reliable.
> Certainly it was known to fail on some machines,
> but more importantly, APM machines have not shipped
> for a decade and so finding machines to test the code
> is problematic.
> 
> After this patch, systems running in APM mode will
> simply run default_idle() and HALT without calling
> into the BIOS from their idle loop.
> 
> This deletes a much-maligned modular user of the (pm_idle)()
> function pointer.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Ok, this should have far less negative impact on old hardware.

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
