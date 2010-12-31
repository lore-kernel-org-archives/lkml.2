Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0LaOXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:23:46 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:39119 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0LaOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:23:45 -0500
Date: Fri, 31 Dec 2010 09:23:36 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Anca Emanuel <anca.emanuel@gmail.com>
cc: Ubuntu kernel team mailing list <kernel-team@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: is there a fix for ubuntu with intel GPU booting to blank
 screen?
In-Reply-To: <AANLkTiktLCVQgGPCyt-fwVSkVmr8Ljr08UmvtkNG_zdp@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1012310836370.23681@localhost6.localdomain6>
References: <alpine.DEB.2.00.1012270640240.3071@localhost6.localdomain6> <AANLkTiktLCVQgGPCyt-fwVSkVmr8Ljr08UmvtkNG_zdp@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811071-1506334730-1293804266=:23681"
Content-ID: <alpine.DEB.2.00.1012310917040.3124@localhost6.localdomain6>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811071-1506334730-1293804266=:23681
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1012310917041.3124@localhost6.localdomain6>

On Fri, 31 Dec 2010, Anca Emanuel wrote:

> On Mon, Dec 27, 2010 at 1:50 PM, Robert P. J. Day <rpjday@crashcourse.ca>=
 wrote:
> >
> > =A0i've posted on a couple other lists but i figured i'd ask the
> > experts. =A0on my updated/upgraded ubuntu system (gateway NV79 with
> > intel GPU), i've built my own kernel from the latest linus git tree as
> > i've done many times in the past, but this kernel boots to a blank
> > screen. =A0here's a reference that seems to nicely summarize my
> > situation:
> >
> > =A0https://bugs.launchpad.net/ubuntu/+source/linux/+bug/561802
> >
> > =A0weirdly, i'm currently running an earlier "rc" hand-rolled git
> > kernel which works fine:
> >
> > $ uname -a
> > Linux lynx 2.6.37-rc5+ #1 SMP Fri Dec 10 12:09:02 EST 2010 x86_64 GNU/L=
inux
> > $
> >
> > (even though it says lynx, it's maverick simply fully updated.)
> >
> > =A0and this is from lspci:
> >
> > 00:02.0 VGA compatible controller: Intel Corporation Core Processor
> > Integrated Graphics Controller (rev 12) (prog-if 00 [VGA controller])
> > =A0 =A0 =A0 =A0Subsystem: Acer Incorporated [ALI] Device 031c
> > =A0 =A0 =A0 =A0Flags: bus master, fast devsel, latency 0, IRQ 41
> > =A0 =A0 =A0 =A0Memory at d0000000 (64-bit, non-prefetchable) [size=3D4M=
]
> > =A0 =A0 =A0 =A0Memory at c0000000 (64-bit, prefetchable) [size=3D256M]
> > =A0 =A0 =A0 =A0I/O ports at 3050 [size=3D8]
> > =A0 =A0 =A0 =A0Expansion ROM at <unassigned> [disabled]
> > =A0 =A0 =A0 =A0Capabilities: <access denied>
> > =A0 =A0 =A0 =A0Kernel driver in use: i915
> > =A0 =A0 =A0 =A0Kernel modules: i915
> > ... snip ..
> >
> > =A0i've tried various suggestions from google, as in "modeset noacpi"
> > and others, but nothing works to get video on my rc7+ kernel. =A0the
> > rc5+ verison, though, boots properly without incident. =A0and the link =
i
> > gave to launchpad above suggests, at the bottom, that even as late as
> > dec 12, people were still having problems.
> >
> > =A0i'm open to suggestions, not scared to patch my kernel source and
> > rebuild and reboot.
>
> CC: lkml
>
> did you tried 2.6.37-rc8-git1 ?

  i just did a "git pull" to get the latest (-rc8) and "git log" shows
me:

commit 3643e0e87c13c670a0fdcd0c34401b38b36ff021
Merge: e983dc2 cc6455f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Dec 30 12:09:26 2010 -0800

    Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/ickle/drm-intel

    * 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ic=
kle/drm-intel:
      drm/i915/dvo: Report LVDS attached to ch701x as connected
      Revert "drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks"
      drm/i915: Verify Ironlake eDP presence on DP_A using the capability f=
use
      drm/i915, intel_ips: When i915 loads after IPS, make IPS relink to i9=
15.
      drm/i915/sdvo: Add hdmi connector properties after initing the connec=
tor
      drm/i915: Set the required VFMUNIT clock gating disable on Ironlake.


  no change, still prints "failed to load i915 symbols, graphics turbo
disabled" just before it all goes black but it clearly continues to
boot.

  not to sound self-important but this is kind of a show-stopper, is
it not?  right now, i have exactly one bootable kernel (hand-rolled
2.6.37-rc5+) and i have no idea *why* that one boots properly but,
under the circumstances, i can't move on.  i'm willing to do any
testing if that would help the cause but i suspect enough people are
already digging into this so i'll just be patient and test the next
pass to see if that solves it.

rday

--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
---1463811071-1506334730-1293804266=:23681--
