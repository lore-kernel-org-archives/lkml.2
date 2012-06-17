Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2FQToi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 15:44:38 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53368 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2FQToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 15:44:37 -0400
Date: Sun, 17 Jun 2012 21:46:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>
Subject: Re: [git pull] drm-fixes
Message-ID: <20120617194609.GC4798@phenom.ffwll.local>
Mail-Followup-To: torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Dave Airlie <airlied@gmail.com>
References: <alpine.DEB.2.00.1206170838050.26175@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1206170838050.26175@skynet.skynet.ie>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This pull also contains the fix for the eDP dmesg noise you've reported
(turned out to be a regression introduced in 3.5). Please yell if you
still see them. The DP regression Dave mentioned is a different bug
introduced in 3.4.

Thanks, Daniel

On Sun, Jun 17, 2012 at 08:42:28AM +0100, Dave Airlie wrote:
> Hi Linus,
> 
> radeon is most of the work, one regression, one BUG fix in the new prime 
> code, some fixes to init code to make streamout not lock up the hardware, 
> and just some code to enable users to test HDMI audio on later hw (its off by 
> default).
> 
> Intel adds edp edid caching for some strange Dell Vostros that black 
> screen on startup if keep reading their EDID, and a fix for a DP 
> regression.
> 
> Otherwise fix for via/sis and one to stop udl binding to multiple 
> non-video usb.
> 
> Dave.
> 
> The following changes since commit 9b15b817f3d62409290fd56fe3cbb076a931bb0a:
> 
>   swap: fix shmem swapping when more than 8 areas (2012-06-15 21:48:14 -0700)
> 
> are available in the git repository at:
> 
>   git://people.freedesktop.org/~airlied/linux drm-fixes
> 
> for you to fetch changes up to c4af5c4597a7a5d64e058703e1328f315a59794e:
> 
>   Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2012-06-16 14:45:17 +0100)
> 
> ----------------------------------------------------------------
> 
> Alex Deucher (3):
>       drm/radeon: fix regression in dynpm due to multi-ring rework
>       drm/radeon: add some additional 6xx/7xx/EG register init
>       drm/radeon: add support for STRMOUT_BASE_UPDATE on 7xx
> 
> Daniel Vetter (2):
>       drm/i915: eDP aux needs vdd
>       Revert "drm/i915/dp: Use auxch precharge value of 5 everywhere"
> 
> Dave Airlie (3):
>       drm/udl: only bind to the video devices on the hub.
>       drm/radeon/prime: reserve/unreserve around pin
>       Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
> 
> Jesse Barnes (2):
>       drm/i915: don't enumerate HDMID if an eDP panel is already active on the port
>       drm/i915: cache the EDID for eDP panels
> 
> Márton Németh (2):
>       drm via: initialize object_idr
>       drm sis: initialize object_idr
> 
> Rafał Miłecki (1):
>       drm/radeon: enable HDMI on DCE5 (AKA NI excluding Aruba)
> 
> Randy Dunlap (1):
>       vga_switcheroo.h: fix pci_dev warning
> 
>  drivers/gpu/drm/i915/intel_display.c       |    2 +-
>  drivers/gpu/drm/i915/intel_dp.c            |   60 ++++++++++++++++++++++++----
>  drivers/gpu/drm/radeon/atombios_encoders.c |    4 +-
>  drivers/gpu/drm/radeon/evergreen.c         |    3 ++
>  drivers/gpu/drm/radeon/evergreen_hdmi.c    |    3 --
>  drivers/gpu/drm/radeon/evergreend.h        |    1 +
>  drivers/gpu/drm/radeon/ni.c                |    5 +++
>  drivers/gpu/drm/radeon/r600.c              |    1 +
>  drivers/gpu/drm/radeon/r600_audio.c        |    2 +-
>  drivers/gpu/drm/radeon/r600_cs.c           |   42 +++++++++++++++++++
>  drivers/gpu/drm/radeon/r600_hdmi.c         |    7 +---
>  drivers/gpu/drm/radeon/r600d.h             |    2 +
>  drivers/gpu/drm/radeon/radeon_drv.c        |    3 +-
>  drivers/gpu/drm/radeon/radeon_pm.c         |   10 +++--
>  drivers/gpu/drm/radeon/radeon_prime.c      |   10 ++++-
>  drivers/gpu/drm/radeon/rv770.c             |    5 ++-
>  drivers/gpu/drm/radeon/rv770d.h            |    3 ++
>  drivers/gpu/drm/sis/sis_drv.c              |    2 +-
>  drivers/gpu/drm/udl/udl_drv.c              |   15 ++++++-
>  drivers/gpu/drm/via/via_map.c              |    3 +-
>  include/linux/vga_switcheroo.h             |    2 +
>  21 files changed, 156 insertions(+), 29 deletions(-)

> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel


-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
