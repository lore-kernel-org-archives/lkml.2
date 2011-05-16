Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1EPREM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:04:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:24014 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab1EPREL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:04:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,375,1301900400"; 
   d="scan'208";a="2356655"
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110516113205.GF19837@elte.hu>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
	 <20110510073551.GH11595@elte.hu>
	 <BANLkTik0GTwV0Z21+UO69JX0cqjxwqu7jw@mail.gmail.com>
	 <1305071894.2736.50.camel@sbsiddha-MOBL3.sc.intel.com>
	 <BANLkTimvX3YXTxVSHDFm1N9a8vsALufrMg@mail.gmail.com>
	 <1305308919.27535.19.camel@sbsiddha-MOBL3.sc.intel.com>
	 <BANLkTik3sE-z3QdHVwW5uPXDDFj=3zMyDg@mail.gmail.com>
	 <20110516113205.GF19837@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 16 May 2011 10:04:31 -0700
Message-Id: <1305565471.26846.4.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 04:32 -0700, Ingo Molnar wrote: 
> * Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> 
> > Hi Suresh,
> > 
> > On 14 May 2011 01:48, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > > On Wed, 2011-05-11 at 09:15 -0700, Daniel J Blueman wrote:
> > >> Superb, this works, tested against 2.6.39-rc7 and addresses the "BUG:
> > >> sleeping function called from invalid context at mm/slub.c:824"
> > >> warning I was previously seeing. It would be good to get this fix into
> > >> 2.6.39-final if possible.
> > >>
> > >> Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
> > >
> > > Thanks Daniel for testing my quick patch. I have appended the complete
> > > patch which cleans up this code.
> > >
> > > Ingo, This patch is relatively big (mostly removes the duplicate code
> > > and changes the location where we allocate ioapic_saved_data, so that
> > > this can be shared between interrupt-remapping and io-apic
> > > suspend/resume flows). May be this can go into 2.6.40-rc1 and probably
> > > go to 2.6.39-stable?
> > >
> > > Or we can take the Daniel's GFP_ATOMIC patch for 2.6.39 and push this
> > > patch for 2.6.40-rc1. I am ok either way.
> > []
> > 
> > Testing this, all looks well in that the patch resolves the
> > potentially sleeping allocation, however I do see (on boot) this
> > suspicious message (though suspend and resume does work):
> > 
> > IOAPIC 0: suspend/resume impossible!
> > 
> > I guess it's not expected...

oops. I had a spurious initialization, from the earlier attempts to fix
this that was still left out.

> No. Has this been introduced by Suresh's patch?

Ofcourse yes ;(

Will fix this and split the patch into multiple steps.

thanks,
suresh

