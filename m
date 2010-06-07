Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab0FGWmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 18:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab0FGWmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 18:42:20 -0400
Subject: Re: [Regression, post-rc1] Multiple issues after enabling
 SetVoltage on rs780m
From: Dave Airlie <airlied@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net
In-Reply-To: <201006072337.17778.rjw@sisk.pl>
References: <201006071129.32159.rjw@sisk.pl>
	 <AANLkTinx-5-jjtnYnUAsl-DvFtbL6wtyPnALdri0d-d2@mail.gmail.com>
	 <AANLkTilerIhYtHlX0vNAg_pfG_1100OymKV4aaGv-VSE@mail.gmail.com>
	 <201006072337.17778.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 08:37:18 +1000
Message-ID: <1275950238.3125.0.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 23:37 +0200, Rafael J. Wysocki wrote:
> On Monday 07 June 2010, Alex Deucher wrote:
> > On Mon, Jun 7, 2010 at 6:15 AM, Dave Airlie <airlied@gmail.com> wrote:
> > > On Mon, Jun 7, 2010 at 7:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> Hi Alex,
> > >>
> > >> Your commit 9349d5cc920c10845693f906ebd67f394f1d0d04
> > >> (drm/radeon/kms/pm: enable SetVoltage on r7xx/evergreen) has caused my test-bed
> > >> Acer Ferrari One to behave quite unreliably.  The symptoms are:
> > >>
> > >> - the system hangs hard (~ 50% of the time) when starting Xorg
> > >> - the system hangs hard (~ 50% of the time) when stopping Xorg during system
> > >>  reboot
> > >> - the system sometimes hangs hard during suspend to RAM
> > >>
> > >> These problems are not reproducible with the commit above reverted.
> > >>
> > >> Below is the information about the graphics adapter from lspci.
> > >
> > > Reverting that commit on master fixes it?
> > >
> > > that commit touches code paths in rv770 and evergreen that in no way
> > > should affect that chipset which is an rs780, so takes the r600 paths.
> > >
> > > are you sure its not 7ac9aa5a1f1b87adb69bcbec2b89e228f074103a?
> > 
> > It should be that commit if it is indeed the voltage adjust.  That
> > said, I just took a closer look at the voltage adjust on newer IGPs
> > and unfortunately, it doesn't work the same as the discrete cards, so
> > for now we should disable it.  The attached patch should do the trick.
> >  There weren't any problems on my IGP chips, but they don't have a
> > SetVoltage table, so nothing is touching the hw.
> 
> I'm not sure if the adapter is a discrete one.
> 
> Anyway, my testing was done before commit
> 386f40c86d6c8d5b717ef20620af1a750d0dacb4 and I'm unable to reproduce the
> problems with current -git, so they might be a fallout of the bug fixed by that
> commit.
> 

Yeah the sounded a lot more like the vt.c crapfest, since it was when
starting/stopping X.

Dave.


