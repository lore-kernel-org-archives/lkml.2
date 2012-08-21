Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab2HUScp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:32:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50158 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277Ab2HUScj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:32:39 -0400
Date: Tue, 21 Aug 2012 20:33:01 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: inux-next: Tree for Aug 21 (call-trace when suspending: PM?)
Message-ID: <20120821183301.GG5156@phenom.ffwll.local>
Mail-Followup-To: Sedat Dilek <sedat.dilek@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
	Al Viro <viro@zeniv.linux.org.uk>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
References: <CA+icZUWg7qEFvAsTMb9OFKmdW7XD4op14Ps2y6PLByZRArjeLg@mail.gmail.com>
 <CA+icZUVjr6aaopVAhGRr13RLDy=epdnU30YTHOhjXmrWb2sAjA@mail.gmail.com>
 <CA+icZUXD+oWqTKB2b_xu8UEDnX6mSs_aELaGu9UQs_U4fHaKGQ@mail.gmail.com>
 <CAKMK7uFr972_aC8+HojLYe+Dsa0Abo0_qkLq8mbgSQs09sXihQ@mail.gmail.com>
 <CA+icZUVVjJ8wzJjM=Agw7xU65qgSekwW++wo_vNe_YELUT0bWA@mail.gmail.com>
 <CAKMK7uHfLOOWLfw6QJP4RQOoD3znOqZcY-qF-ry77z1seLWmBw@mail.gmail.com>
 <CA+icZUXGpTMgP7BX-RWHK=pKMu3x9z7UnHiDELDg94esW24FvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXGpTMgP7BX-RWHK=pKMu3x9z7UnHiDELDg94esW24FvA@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 08:20:35PM +0200, Sedat Dilek wrote:
> On Tue, Aug 21, 2012 at 6:39 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Tue, Aug 21, 2012 at 3:24 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >> On Tue, Aug 21, 2012 at 1:53 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> >>> On Tue, Aug 21, 2012 at 1:14 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>> On Tue, Aug 21, 2012 at 1:03 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>>> On Tue, Aug 21, 2012 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>>>> On Tue, Aug 21, 2012 at 8:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >>>>>>> Hi all,
> >>>>>>>
> >>>>>>> Changes since 20120820:
> >>>>>>>
> >>>>>>> The rr tree gained a conflict against Linus' tree.
> >>>>>>>
> >>>>>>> The tip tree still has its build failure so I used the version from
> >>>>>>> next-20120814.
> >>>>>>>
> >>>>>>> The workqueues tree gained a conflict against the hid tree.
> >>>>>>>
> >>>>>>> The drivers-x86 tree still has its build failure so I used the version
> >>>>>>> from next-20120817.
> >>>>>>>
> >>>>>>> The signal tree gained a conflict against Linus' tree.  I have still
> >>>>>>> reverted 3 commits from the signal tree at the request of the arm
> >>>>>>> maintainer.
> >>>>>>>
> >>>>>>> ----------------------------------------------------------------------------
> >>>>>>>
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>> I have compiled linux-next (next-20120821) and see the attached
> >>>>>> call-trace when suspending.
> >>>>>> Suspending did NOT work (Xorg seems to cause it) - machine came back to desktop.
> >>>>>>
> >>>>>> With yesterday's next-20120820 I haven't seen this.
> >>>>>>
> >>>>>> I am not sure what is this causing... PM, x86/sched or even VFS?
> >>>>>> Any help for debugging appreciated.
> >>>>>>
> >>>>>> I am on Ubuntu/precise AMD64 and use systemd-v43 as init-system.
> >>>>>>
> >>>>>> Regards,
> >>>>>> - Sedat -
> >>>>>
> >>>>> Forgot attachment!
> >>>>> If you don't succeed - try try try...
> >>>>>
> >>>>> - Sedat -
> >>>>
> >>>> [ CC danvet ]
> >>>>
> >>>> I have pulled in drm-intel-fixes into my local GIT tree and rebuilt
> >>>> i915 - this seems to fix the problem.
> >>>> Daniel any suggestion which patch in d-i-f did it?
> >>>
> >>> Without the backtrace it's kinda hard to tell ... Also, if you can
> >>> dump a git log of the commits from -fixes that you don't yet have.
> >>> -Daniel
> >>>
> >>
> >> Hi Daniel,
> >>
> >> $ git log --oneline v3.6.0-rc2-next20120821-1-iniza-generic..drm-intel-fixes
> >> 1ee9ae3 drm/i915: use hsw rps tuning values everywhere on gen6+
> >> f1a2f5b drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads
> >> 4eab813 drm/i915: extract connector update from intel_ddc_get_modes() for reuse
> >> a843af1 drm/i915: fix hsw uncached pte
> >> b6c7488 drm/i915/contexts: fix list corruption
> >> 38ab8a2 drm/i915: fix EDID memory leak in SDVO
> >>
> >> Looks like "1ee9ae3 drm/i915: use hsw rps tuning values everywhere on
> >> gen6+" has PM fixes for i915.
> >>
> >> I tried with only that patch on top of today's linux-next - and I can
> >> suspend/resume again!
> >
> > Well, this is slightly shocking - this patch /should/ only optimize
> > power consumption, it should in now way fix suspend/resume (i.e. it
> > doesn't even apply any h/w workaround). Do you have any more details
> > what's going wrong here (logs, ...)?
> >
> 
> Forgot to CC you on my 1st emails.
> [2] has the call-trace I have seen.
> 
> - Sedat -
> 
> [2] http://marc.info/?l=linux-next&m=134554704504603&w=2

Hm, that smells more like a race, and changing the gpu turbo settins is
known to rather massively move such races around (since this affects the
power consumption and hence also max cpu turbo states, besides massively
changing wakeup latency, since only when the gpu is in rc6 the entire
cpu+gpu package can go into the lowest power state).

I'd wager this thing will pop up again :(
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
