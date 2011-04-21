Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1DULVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:21:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1DULVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:21:40 -0400
Date: Thu, 21 Apr 2011 13:21:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Russ Anderson <rja@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
 errors
Message-ID: <20110421112121.GA21929@elte.hu>
References: <1302857141-17580-1-git-send-email-bp@amd64.org>
 <66D9D2F0CDB5C9428E6166B01EC85EE162EF92B0F3@GVW0676EXC.americas.hpqcorp.net>
 <20110421093554.GB4262@elte.hu>
 <20110421095114.GB10263@aftab>
 <20110421095848.GA14889@elte.hu>
 <20110421100639.GC10263@aftab>
 <20110421102000.GD10263@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421102000.GD10263@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> On Thu, Apr 21, 2011 at 06:06:39AM -0400, Borislav Petkov wrote:
> > On Thu, Apr 21, 2011 at 05:58:48AM -0400, Ingo Molnar wrote:
> > > Ok, indeed. Also, in the future, if you take patches from others please also 
> > > credit them in the changelog. Something like this would have been good in the 
> > > current case:
> > > 
> > >   Also, this patch includes a change from Nagananda Chumbalkar as well, which 
> > >   drops tainting in the therma throttling code for a similar reason: crossing a
> > >   thermal threshold does not mean corruption.
> > > 
> > > Nagananda's Acked-by is there so there's at least partial credit - but we 
> > > generally try to aim for at least 100% credit where credit is due :-)
> > 
> > Absolutely, and in the light of recent events :) I'm still not sure how
> > to do that though in a straight-forward manner so that it is visible at
> > a first glance. Sure, adding freeform text to the commit message is one
> > way. Using a SOB chain might work too - even the Acked-by tag - but all
> > those have another main purpose and are being repurposed for annotating
> > the fact that a patch is the result of more than one author's thought
> > process.
> > 
> > IOW, in case I'm not missing anything, we don't really have a way to
> > denote a multiple authorship, correct? And we should...
> 
> Ok, after RTFMing <Documentation/SubmittingPatches> here's how:
> 
> From: Original Author <author@example.com>
> 
> 	^ this is the original author who sent the initial patch
> 
> Signed-off-by: Original Author <author@example.com>
> Signed-off-by: Additional Author <author2@example.com>
> Signed-off-by: Third Author <author3@example.com>

The easiest solution is to create a separate patch for the TM1/TM2 change and 
ask for a SOB :-)

Thanks,

	Ingo
