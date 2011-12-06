Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab1LFFcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 00:32:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab1LFFct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 00:32:49 -0500
X-Greylist: delayed 56061 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Dec 2011 00:32:49 EST
Date: Tue, 6 Dec 2011 06:31:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mm] x86/mm: Avoid superflous leave_mm() in the TLB
 flush path
Message-ID: <20111206053100.GA30784@elte.hu>
References: <tip-287de5b2cb365b98190b5de8ace1c5a31768a5ae@git.kernel.org>
 <CA+55aFwMfUduX_5kNKjo=S8ShEBb_OE_D6o-jSMy53Sa0iZHAw@mail.gmail.com>
 <1323132020.22361.364.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323132020.22361.364.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shaohua Li <shaohua.li@intel.com> wrote:

> On Tue, 2011-12-06 at 07:26 +0800, Linus Torvalds wrote:
> > On Mon, Dec 5, 2011 at 9:56 AM, tip-bot for Shaohua Li
> > <shaohua.li@intel.com> wrote:
> > >
> > > x86/mm: Avoid superflous leave_mm() in the TLB flush path
> > >
> > > If just one page VA tlb is required to be flushed and current
> > > task is in lazy TLB state, doing leave_mm() is superfluous
> > > because it flushes the whole TLB.  This can reduce some TLB
> > > miss.
> > 
> > Are you sure this is a good idea?
> > 
> > We may be *much* better off leaving the VM and avoiding future IPI's
> > than trying to flush pages one by one over and over again.
> > 
> > IPI's are expensive.
> > 
> > I don't think you thought this through, and if you *did* think it
> > through and actually have numbers that it's cheaper to stay with the
> > MM, I think you need to show those numbers.
>
> good point, I didn't think of it. It's unlikely we just flush 
> one tlb page. please drop the patch.

Dropped, thanks guys.

	Ingo
