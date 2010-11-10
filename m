Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0KJUws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:52:48 -0500
Received: from www.tglx.de ([62.245.132.106]:46564 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab0KJUwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:52:46 -0500
Date: Wed, 10 Nov 2010 21:52:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Lutomirski <luto@mit.edu>
cc: Borislav Petkov <bp@amd64.org>, Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        =?ISO-8859-15?Q?J=F6rg_R=F6del?= <joerg.roedel@amd.com>
Subject: Re: [FALSE ALARM] Re: HPET (?) related hangs and breakage in
 2.6.35,36
In-Reply-To: <AANLkTimNuSJz0nXZCR2zu963VQ_Y9R8ix73+QbbUy7nt@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1011102147580.2900@localhost6.localdomain6>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com> <4CD966D8.4000602@ladisch.de> <20101109153805.GB3146@kryptos.osrc.amd.com> <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com> <20101109180123.GB31121@aftab>
 <AANLkTik107mFOqvxsBtBrc14RHwhkkZTOGgctxKPPNfW@mail.gmail.com> <AANLkTik1JdQRh_Gkz_240csVGp4sS0W8nzR5d9Pv1G-X@mail.gmail.com> <20101110185031.GB13539@aftab> <AANLkTimNuSJz0nXZCR2zu963VQ_Y9R8ix73+QbbUy7nt@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-541760400-1289422338=:2900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-541760400-1289422338=:2900
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 10 Nov 2010, Andrew Lutomirski wrote:

> On Wed, Nov 10, 2010 at 1:50 PM, Borislav Petkov <bp@amd64.org> wrote:
> > On Wed, Nov 10, 2010 at 01:48:00PM -0500, Andrew Lutomirski wrote:
> >> > Clocksource: tsc unstable (delta = -34355296774 ns)
> >> > Switching: to clocksource hpet
> >>
> >> Please disregard -- this is a bug in nouveau (or drm) not hpet.  I'll
> >> send a bug report to the maintainers.
> >
> > Interesting! Joerg was complaining about similar symptoms with .36 today
> > too.
> 
> Well, there is a clocksource sort-of-bug that could cause confusion:
> when something totally unrelated to clocksources goes out to lunch,
> the clocksource watchdog decides that the clocksource is unstable and
> complains, steering everyone toward filing the wrong bug.

How should the clocksource watchdog code know that something went to
lunch? The fact that we need to monitor TSC at all is horrible enough,
adding further heuristics to detect extended lunch breaks would be
just a PITA.

Maybe we could print a different warning when we see large negative
deltas, which is the main indicator for the system being stuck for
quite a time while TSC advances happily.

Thanks,

	tglx
---1463795968-541760400-1289422338=:2900--
