Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0FSNaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 09:30:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53770 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab0FSNaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 09:30:02 -0400
Date: Sat, 19 Jun 2010 15:30:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft
 page offlining
Message-ID: <20100619133000.GL18946@basil.fritz.box>
References: <200912081016.198135742@firstfloor.org>
 <20091208211647.9B032B151F@basil.firstfloor.org>
 <AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com>
 <20100619132055.GK18946@basil.fritz.box>
 <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 03:25:16PM +0200, Michael Kerrisk wrote:
> Hi Andi,
> 
> Thanks for this. Some comments below.
> 
> On Sat, Jun 19, 2010 at 3:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > On Sat, Jun 19, 2010 at 02:36:28PM +0200, Michael Kerrisk wrote:
> >> Hi Andi,
> >>
> >> On Tue, Dec 8, 2009 at 11:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> >
> >> > Process based injection is much easier to handle for test programs,
> >> > who can first bring a page into a specific state and then test.
> >> > So add a new MADV_SOFT_OFFLINE to soft offline a page, similar
> >> > to the existing hard offline injector.
> >>
> >> I see that this made its way into 2.6.33. Could you write a short
> >> piece on it for the madvise.2 man page?
> >
> > Also fixed the previous snippet slightly.
> 
> (thanks)
> 
> > commit edb43354f0ffc04bf4f23f01261f9ea9f43e0d3d
> > Author: Andi Kleen <ak@linux.intel.com>
> > Date:   Sat Jun 19 15:19:28 2010 +0200
> >
> >    MADV_SOFT_OFFLINE
> >
> >    Signed-off-by: Andi Kleen <ak@linux.intel.com>
> >
> > diff --git a/man2/madvise.2 b/man2/madvise.2
> > index db29feb..9dccd97 100644
> > --- a/man2/madvise.2
> > +++ b/man2/madvise.2
> > @@ -154,7 +154,15 @@ processes.
> >  This operation may result in the calling process receiving a
> >  .B SIGBUS
> >  and the page being unmapped.
> > -This feature is intended for memory testing.
> > +This feature is intended for testing of memory error handling code.
> > +This feature is only available if the kernel was configured with
> > +.BR CONFIG_MEMORY_FAILURE .
> > +.TP
> > +.BR MADV_SOFT_OFFLINE " (Since Linux 2.6.33)
> > +Soft offline a page. This will result in the memory of the page
> > +being copied to a new page and original page be offlined. The operation
> 
> Can you explain the term "offlined" please.

The memory is not used anymore and taken out of normal
memory management (until unpoisoned) 
and the "HardwareCorrupted:" counter in /proc/meminfo increases

(don't put the later in, I'm thinking about changing that)

> 
> > +should be transparent to the calling process.
> 
> Does "should be transparent" mean "is normally invisible"?

Yes. It's similar to being swapped out and swapped in again.

-Andi
