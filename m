Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0LaQsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 11:48:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64387 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0LaQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 11:48:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lfQxSHTxivKXICEaAdUSkA/ZAe7KwhYJzvwDhu5NDM7vFrlEeVn1l6+9XOtckff7Dq
         drgiJZTycq/0CBJsdBNF0p1goK1476jcqbLv3Tmg4iBEFwd6VbFfPwSJGzm1NvlCz/Zd
         mTEEENcBkshHRprVzuVarKzOR+XoLmGRXoONw=
Subject: Re: is there a fix for ubuntu with intel GPU booting to blank
 screen?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Anca Emanuel <anca.emanuel@gmail.com>,
        Ubuntu kernel team mailing list 
	<kernel-team@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
In-Reply-To: <alpine.DEB.2.00.1012310836370.23681@localhost6.localdomain6>
References: <alpine.DEB.2.00.1012270640240.3071@localhost6.localdomain6>
	 <AANLkTiktLCVQgGPCyt-fwVSkVmr8Ljr08UmvtkNG_zdp@mail.gmail.com>
	 <alpine.DEB.2.00.1012310836370.23681@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 18:48:09 +0200
Message-ID: <1293814089.6993.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-31 at 09:23 -0500, Robert P. J. Day wrote:
> On Fri, 31 Dec 2010, Anca Emanuel wrote:
> 
> > On Mon, Dec 27, 2010 at 1:50 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > >
> > >  i've posted on a couple other lists but i figured i'd ask the
> > > experts.  on my updated/upgraded ubuntu system (gateway NV79 with
> > > intel GPU), i've built my own kernel from the latest linus git tree as
> > > i've done many times in the past, but this kernel boots to a blank
> > > screen.  here's a reference that seems to nicely summarize my
> > > situation:
> > >
> > >  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/561802
> > >
> > >  weirdly, i'm currently running an earlier "rc" hand-rolled git
> > > kernel which works fine:
> > >
> > > $ uname -a
> > > Linux lynx 2.6.37-rc5+ #1 SMP Fri Dec 10 12:09:02 EST 2010 x86_64 GNU/Linux
> > > $
> > >
> > > (even though it says lynx, it's maverick simply fully updated.)
> > >
> > >  and this is from lspci:
> > >
> > > 00:02.0 VGA compatible controller: Intel Corporation Core Processor
> > > Integrated Graphics Controller (rev 12) (prog-if 00 [VGA controller])
> > >        Subsystem: Acer Incorporated [ALI] Device 031c
> > >        Flags: bus master, fast devsel, latency 0, IRQ 41
> > >        Memory at d0000000 (64-bit, non-prefetchable) [size=4M]
> > >        Memory at c0000000 (64-bit, prefetchable) [size=256M]
> > >        I/O ports at 3050 [size=8]
> > >        Expansion ROM at <unassigned> [disabled]
> > >        Capabilities: <access denied>
> > >        Kernel driver in use: i915
> > >        Kernel modules: i915
> > > ... snip ..
> > >
> > >  i've tried various suggestions from google, as in "modeset noacpi"
> > > and others, but nothing works to get video on my rc7+ kernel.  the
> > > rc5+ verison, though, boots properly without incident.  and the link i
> > > gave to launchpad above suggests, at the bottom, that even as late as
> > > dec 12, people were still having problems.
> > >
> > >  i'm open to suggestions, not scared to patch my kernel source and
> > > rebuild and reboot.
> >
> > CC: lkml
> >
> > did you tried 2.6.37-rc8-git1 ?
> 
>   i just did a "git pull" to get the latest (-rc8) and "git log" shows
> me:
> 
> commit 3643e0e87c13c670a0fdcd0c34401b38b36ff021
> Merge: e983dc2 cc6455f
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Dec 30 12:09:26 2010 -0800
> 
>     Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel
> 
>     * 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel:
>       drm/i915/dvo: Report LVDS attached to ch701x as connected
>       Revert "drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks"
>       drm/i915: Verify Ironlake eDP presence on DP_A using the capability fuse
>       drm/i915, intel_ips: When i915 loads after IPS, make IPS relink to i915.
>       drm/i915/sdvo: Add hdmi connector properties after initing the connector
>       drm/i915: Set the required VFMUNIT clock gating disable on Ironlake.
> 
> 
>   no change, still prints "failed to load i915 symbols, graphics turbo
> disabled" just before it all goes black but it clearly continues to
> boot.
> 
>   not to sound self-important but this is kind of a show-stopper, is
> it not?  right now, i have exactly one bootable kernel (hand-rolled
> 2.6.37-rc5+) and i have no idea *why* that one boots properly but,
> under the circumstances, i can't move on.  i'm willing to do any
> testing if that would help the cause but i suspect enough people are
> already digging into this so i'll just be patient and test the next
> pass to see if that solves it.
Since you know how to compile kernel, and even have a close working
version, you really should just bisect the bug.

Bisection is a built-in in the git binary search that allows you to find
the first commit that introduced the bug.

For example, quick google gives,
http://www.kernel.org/pub/software/scm/git-core/docs/v1.0.13/howto/isolate-bugs-with-bisect.txt

Best regards,
	Maxim Levitsky




