Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1ANWxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:53:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49729 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab1ANWxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:53:09 -0500
Date: Fri, 14 Jan 2011 22:52:47 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915/execbuffer: Clear domains before beginning
 reloc processing
In-Reply-To: <849307$b5cdqe@azsmga001.ch.intel.com>
Message-ID: <alpine.DEB.2.00.1101142251300.10016@skynet.skynet.ie>
References: <AANLkTinBnm+xkXPPM4-3PG_i2hJMuXhv8x42KN4o3kGg@mail.gmail.com> <1294916869-2417-1-git-send-email-chris@chris-wilson.co.uk> <AANLkTimypim707rEXaPBaKoGgGmz3Of4EmPNw7VokJL6@mail.gmail.com> <1bdc18$j8l825@fmsmga002.fm.intel.com>
 <AANLkTinq9MOjvHVFb1eJ_Dt+vkgpixuUrU-xcDYGZ5Lj@mail.gmail.com> <849307$b5cdqe@azsmga001.ch.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ack from me for direct pull, I'm not flooded but I have no access to my 
dev machines in the office which all got powered down.

I've also been distracted with some deadlines for the bill payers.

Dave.

On Fri, 14 Jan 2011, Chris Wilson wrote:

> [Let's try this again. There are times when I merely dislike my VPN.]
> 
> On Fri, 14 Jan 2011 09:37:20 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Thu, Jan 13, 2011 at 8:10 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > >
> > > They will be in drm-intel-fixes. There have been a couple of other patches,
> > > for the compiler warning, the typo that Indan spotted and for modparam to
> > > workaround the U160, so I'll send the pull request it via Dave.
> > 
> > My tree has been in a known-broken state for too damn long now. Please
> > send the pull request to me directly. Dave may be flooded out in
> > Brisbane or something.
> 
> This is what I have waiting in drm-intel-fixes. Besides the regression
> noted above, there is also a critical stability fix for SNB mobile, a
> few patches for older regressions (LVDS on U160, no LVDS on AOpen,
> preserve the backlight value from boot and correct a couple of device
> strings) and one to keep the compiler quiet.
> -Chris
> 
> The following changes since commit f878133bf022717b880d0e0995b8f91436fd605c:
> 
>   Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-01-12 08:40:25 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes
> 
> Chris Wilson (6):
>       drm/i915/debugfs: Correct format after changing type of err object 'size'
>       drm/i915: Add a module option to override the use of SSC
>       drm/i915: Fix error handler to capture the first batch after the seqno
>       drm/i915/execbuffer: Reorder relocations to match new object order
>       drm/i915/execbuffer: Clear domains before beginning reloc processing
>       drm/i915: Disable GPU semaphores on SandyBridge mobile
> 
> Indan Zupancic (1):
>       drm/i915/panel: The backlight is enabled if the current value is non-zero
> 
> Knut Petersen (1):
>       drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS
> 
> Oswald Buddenhagen (1):
>       agp/intel: Fix device names of i845 and 845G
> 
>  drivers/char/agp/intel-agp.c               |    4 ++--
>  drivers/char/agp/intel-gtt.c               |    2 +-
>  drivers/gpu/drm/i915/i915_debugfs.c        |    2 +-
>  drivers/gpu/drm/i915/i915_drv.c            |    3 +++
>  drivers/gpu/drm/i915/i915_drv.h            |    1 +
>  drivers/gpu/drm/i915/i915_gem_execbuffer.c |   25 ++++++++++++++-----------
>  drivers/gpu/drm/i915/i915_irq.c            |    2 +-
>  drivers/gpu/drm/i915/intel_bios.c          |   17 ++++++-----------
>  drivers/gpu/drm/i915/intel_display.c       |   17 +++++++++++------
>  drivers/gpu/drm/i915/intel_lvds.c          |    8 ++++++++
>  drivers/gpu/drm/i915/intel_panel.c         |    2 +-
>  11 files changed, 49 insertions(+), 34 deletions(-)
> 
> 
