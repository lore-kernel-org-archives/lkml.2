Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1EPLcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:32:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53294 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab1EPLcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:32:22 -0400
Date: Mon, 16 May 2011 13:32:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
Message-ID: <20110516113205.GF19837@elte.hu>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
 <20110510073551.GH11595@elte.hu>
 <BANLkTik0GTwV0Z21+UO69JX0cqjxwqu7jw@mail.gmail.com>
 <1305071894.2736.50.camel@sbsiddha-MOBL3.sc.intel.com>
 <BANLkTimvX3YXTxVSHDFm1N9a8vsALufrMg@mail.gmail.com>
 <1305308919.27535.19.camel@sbsiddha-MOBL3.sc.intel.com>
 <BANLkTik3sE-z3QdHVwW5uPXDDFj=3zMyDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik3sE-z3QdHVwW5uPXDDFj=3zMyDg@mail.gmail.com>
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


* Daniel J Blueman <daniel.blueman@gmail.com> wrote:

> Hi Suresh,
> 
> On 14 May 2011 01:48, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > On Wed, 2011-05-11 at 09:15 -0700, Daniel J Blueman wrote:
> >> Superb, this works, tested against 2.6.39-rc7 and addresses the "BUG:
> >> sleeping function called from invalid context at mm/slub.c:824"
> >> warning I was previously seeing. It would be good to get this fix into
> >> 2.6.39-final if possible.
> >>
> >> Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
> >
> > Thanks Daniel for testing my quick patch. I have appended the complete
> > patch which cleans up this code.
> >
> > Ingo, This patch is relatively big (mostly removes the duplicate code
> > and changes the location where we allocate ioapic_saved_data, so that
> > this can be shared between interrupt-remapping and io-apic
> > suspend/resume flows). May be this can go into 2.6.40-rc1 and probably
> > go to 2.6.39-stable?
> >
> > Or we can take the Daniel's GFP_ATOMIC patch for 2.6.39 and push this
> > patch for 2.6.40-rc1. I am ok either way.
> []
> 
> Testing this, all looks well in that the patch resolves the
> potentially sleeping allocation, however I do see (on boot) this
> suspicious message (though suspend and resume does work):
> 
> IOAPIC 0: suspend/resume impossible!
> 
> I guess it's not expected...

No. Has this been introduced by Suresh's patch?

Thanks,

	Ingo
