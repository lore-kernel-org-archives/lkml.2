Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab2C1GkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:40:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44587 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2C1GkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:40:14 -0400
Date: Wed, 28 Mar 2012 08:40:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] floppy: revert floppy disable halt warning
Message-ID: <20120328064008.GA12735@gmail.com>
References: <20120311093853.04f049c2@s6510.linuxnetplumber.net>
 <20120327162633.654c8d7e.akpm@linux-foundation.org>
 <CA+5PVA4KsG0CEs8MhEL2qQoLBU9M6xAoPX2qnTZJ2R5RQ7-osg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA4KsG0CEs8MhEL2qQoLBU9M6xAoPX2qnTZJ2R5RQ7-osg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Boyer <jwboyer@gmail.com> wrote:

> On Tue, Mar 27, 2012 at 7:26 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > (cc some x86 greybeards)
> >
> > On Sun, 11 Mar 2012 09:38:53 -0700
> > Stephen Hemminger <shemminger@vyatta.com> wrote:
> >
> >> Remove the stupid floppy disable halt warning. It is meaningless since
> >> the API is local to floppy driver.  Our boot scripts check for the
> >> floppy drive, and this causes the warning to trigger every time. This
> >> confuses support, breaks automated tests that look for backtraces on
> >> boot,  and adds no value.
> >>
> >> The message is being displayed to the wrong audience, it looks like it
> >> was intended as a compromise of a long discussion on LKML about
> >> supporting older x86 hardware; but users don't know or understand what
> >> it is saying.
> >>
> >> If you want to change halt handling then just fix
> >> the floppy driver, don't whine about it.
> >>
> >> ...
> >>
> >> --- a/drivers/block/floppy.c  2012-03-11 09:27:52.866459327 -0700
> >> +++ b/drivers/block/floppy.c  2012-03-11 09:28:29.286579201 -0700
> >> @@ -1037,7 +1037,6 @@ static void floppy_disable_hlt(void)
> >>  {
> >>       unsigned long flags;
> >>
> >> -     WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
> >>       spin_lock_irqsave(&floppy_hlt_lock, flags);
> >>       if (!hlt_disabled) {
> >>               hlt_disabled = 1;
> >
> > It would have been nice to have provided a pointer to this "long
> > discussion on LKML".  I tried for a while, then gave up.
> >
> > In my search I came across
> > http://lkml.indiana.edu/hypermail/linux/kernel/1104.0/00461.html which
> > does indeed remove all the disable_hlt() code as well as the warning
> > and the feature-removal-schedule.txt record.  Why didn't we merge that?
> > Why shouldn't we merge that now?
> 
> And again 5 months later:
> 
> https://lkml.org/lkml/2011/10/28/313
> 
> Third time's a charm?  I'd buy someone a beverage if we actually went
> through our planned feature removal here...

No objections from me.

Please resubmit against latest -tip, we unified the idle 
routines which likely interacts with that patch.

Thanks,

	Ingo
