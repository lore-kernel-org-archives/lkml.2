Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0IHCiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:38:10 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:53572 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab0IHCiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:38:07 -0400
Date: Tue, 7 Sep 2010 19:38:07 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
        Zou Nan hai <nanhai.zou@intel.com>
Subject: Re: [2.6.36-rc2 regression] X201s: resume-from-S2R hangs
Message-ID: <20100908023807.GL23291@hexapodia.org>
References: <20100906090536.GA12250@hexapodia.org> <87fwxlbhq5.fsf@pollan.anholt.net> <8u3s94$geonkf@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8u3s94$geonkf@orsmga002.jf.intel.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 06:37:55PM +0100, Chris Wilson wrote:
> On Tue, 07 Sep 2010 10:12:34 -0700, Eric Anholt <eric@anholt.net> wrote:
> > On Mon, 6 Sep 2010 02:05:36 -0700, Andy Isaacson <adi@hexapodia.org> wrote:
> > > I have a Thinkpad X201s on which suspend-to-RAM was quite reliable until
> > > after 2.6.36-rc1; with problematic kernels, suspend seems to work OK
> > > (the machine goes to sleep with the moon LED steadily lit) but on resume
> > > the LCD never lights up (and it's not just the backlight, the screen
> > > isn't drawing at all) and the keyboard and network are dead.  Nothing
> > > makes it to syslog, either.  The moon LED is turned off though.
> > > 
> > > There seems to be some timing component to the problem -- some problem
> > > kernels will suspend reliably 25% or 50% of the time and hang the rest.
> > > There also seems to be some per-reboot state involved; one problem
> > > kernel suspended successfully and survived 25 suspends in a row without
> > > triggering a failure.  (But after a reboot, the first suspend hung...)
> > > Other problem kernels fail on 4 out of 4 reboots.
>
> At the moment we have a second resume regression that has been difficult to
> reproduce, https://bugs.freedesktop.org/show_bug.cgi?id=29406 :
> 
> commit d1b851fc0d105caa6b6e3e7c92d2987dfb52cbe0
> Author: Zou Nan hai <nanhai.zou@intel.com>
> Date:   Fri May 21 09:08:57 2010 +0800
> 
>     drm/i915: implement BSD ring buffer V2
> 
> The workaround for this is to #define HAS_BSD(dev) 0 [i915_drv.h].

Setting HAS_BSD 0 does not fix the issue for me.

@@ -1203,7 +1203,7
...
-#define HAS_BSD(dev)            (IS_IRONLAKE(dev) || IS_G4X(dev))
+#define HAS_BSD(dev)            0

As previously reported, reverting ce171780 does seem to do the trick
(I'm a bit more confident having survived another day of use).

> We introduced a timing regression which should be fixed by 
> http://cgit.freedesktop.org/~ickle/drm-intel/ drm-intel-fixes
> [http://cgit.freedesktop.org/~ickle/drm-intel/commit/?id=300387c0b57d75e5218e2881d6ad2720657a8bcf]

Currently building d56557 which includes 300387, will let you know if
that fixes it.

-andy
