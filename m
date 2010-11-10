Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0KJXMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:12:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0KJXMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:12:34 -0500
Subject: Re: [PATCH 2/2] nouveau: Acknowledge HPD irq in handler, not
 bottom half
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Andrew Lutomirski <luto@mit.edu>
Cc: Maarten Maathuis <madman2003@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTimQ9gCMnyJ_sZqOpyeukNKLSuqO7yyJ0AqiOWdx@mail.gmail.com>
References: <cover.1289423299.git.luto@mit.edu>
	 <cb559f4c96f82d5bf0c132b3330aecd4885a0dda.1289423199.git.luto@mit.edu>
	 <1289427037.9605.3.camel@nisroch>
	 <AANLkTimfrVPaxgGXyLU-YTQBMNz_BBVMhfH+MO_CH2Cn@mail.gmail.com>
	 <1289428526.9605.9.camel@nisroch>
	 <AANLkTinBTnJ0OjVkcYDQmYZ_HjqE4NCSHnCvD1_p_DJs@mail.gmail.com>
	 <AANLkTi=bQtqj2D2UWxZiQ0k-oZU4g5JXrsq4tmn9=ZNZ@mail.gmail.com>
	 <AANLkTimQ9gCMnyJ_sZqOpyeukNKLSuqO7yyJ0AqiOWdx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 09:12:09 +1000
Message-ID: <1289430729.9605.15.camel@nisroch>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 18:01 -0500, Andrew Lutomirski wrote:
> On Wed, Nov 10, 2010 at 5:55 PM, Maarten Maathuis <madman2003@gmail.com> wrote:
> > On Wed, Nov 10, 2010 at 11:51 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> >> On Wed, Nov 10, 2010 at 5:35 PM, Ben Skeggs <bskeggs@redhat.com> wrote:
> >>> On Wed, 2010-11-10 at 17:25 -0500, Andrew Lutomirski wrote:
> >>>> On Wed, Nov 10, 2010 at 5:10 PM, Ben Skeggs <bskeggs@redhat.com> wrote:
> >>>> > On Wed, 2010-11-10 at 16:32 -0500, Andy Lutomirski wrote:
> >>>> >> The old code generated an interrupt storm bad enough to completely
> >>>> >> take down my system.
> >>>> >>
> >>>> >> This only fixes the bits that are defined nouveau_regs.h.  Newer hardware
> >>>> >> uses another register that isn't described, and I don't have that hardware
> >>>> >> to test.
> >>>> > Thanks for looking at this.  I'll take a closer look at the problem
> >>>> > today and see what I can come up with too, that'll work with the newer
> >>>> > hardware too.
> >>>>
> >>>> It should be as simple as adding an hpd1 field to the hpd_state and
> >>>> making exactly the same change.  (It would be nice to put the register
> >>>> definitions into nouveau_regs.h as well -- I didn't really want to
> >>>> muck around with a bunch of magic numbers that I can't test.)
> >>> Yes, it is.  I can confirm the problem on another card, but it doesn't
> >>> actually cause any crashes here.  If you can rework the patch to support
> >>> the newer chips too, that'd be great.
> >>>
> >>> As for magic numbers, the register names for those regs are wrong
> >>> anyway.  The joy of reverse-engineering the support.  It doesn't really
> >>> matter if you want to stick to them or go back to "magic" numbers.
> >>
> >> That explains why INTR and CTRL seemed backwards :)  I'll leave the
> >> magic numbers for the 0xe07? stuff.
> >
> > Perhaps remove the bad definitions from the reg file, or rename them
> > to UNKsomething?
> 
> Well, they're known.  One is hotplug detect enable (unless the code is
> wrong) and the other is hotplug interrupt status.
That's also not correct, if anything the most accurate names so far
would probably be:

#define NV_PGPIO_INTR_EN_0 0xe050
#define NV_PGPIO_INTR_0    0xe054
#define NV_PGPIO_INTR_EN_1 0xe070
#define NV_PGPIO_INTR_1    0xe074

PGPIO is a guess, and there's other stuff in that range too, but it's
definitely *not* PCONNECTOR.

Anyway, this doesn't matter.  Whatever change in names can happen in
nouveau git and make it's way to Linus from there, the fix for nouveau
git is already going to be different enough from what'll apply on
Linus' tree right now.  My opinion is, lets just fix the bug in
mainline (without register naming) and fix the naming etc in nouveau
git.

Ben.
> 
> 
> 
> --Andy


