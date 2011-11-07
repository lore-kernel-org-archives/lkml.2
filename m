Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1KGSa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:30:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58716 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1KGSa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:30:26 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy7unJdfb6gz-m-=_5eQH3iFdjK0MKgRoeD5px=CmVQGQ@mail.gmail.com>
References: <alpine.DEB.2.00.1111071323450.8485@skynet.skynet.ie>
	<CA+55aFy7unJdfb6gz-m-=_5eQH3iFdjK0MKgRoeD5px=CmVQGQ@mail.gmail.com>
Date: Mon, 7 Nov 2011 18:30:25 +0000
Message-ID: <CAPM=9twfXuSijpoHjrZ4J=kPfs6YUHNAi13EnDbu+gDoGkfGSw@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 6:00 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Nov 7, 2011 at 5:27 AM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> are available in the git repository at:
>>
>>  ssh://people.freedesktop.org/~/linux drm-fixes
>
> No they are *not* available there.
>
> Fix your pull script already! I mentioned this once earlier, your pull
> requests are wrong, and point to things that just don't *exist* for
> anybody but you.
>
> I don't have ssh access to that server, and even if I did, that "~"
> would be wrong.
>
Oops I generated on my desktop since I was home and it wasn't using
correct script.

Here is a clean version.

Dave.

The following changes since commit 094803e0aab3fe75bbf8202a8f4b5280eaade375:

  Merge branch 'akpm' (Andrew's incoming) (2011-10-31 17:46:07 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (22):
      drm/radeon/kms: rework texture cache flush in r6xx+ blit code
      drm/radeon/kms/cayman/blit: specify CP_COHER_CNTL2 with surface_sync
      drm/radeon/kms: properly set panel mode for eDP
      drm/radeon/kms: cleanup atombios_adjust_pll()
      drm/radeon/kms: rework DP bridge checks
      drm/radeon/kms: only require 2.7 Ghz DP clock for NUTMEG
      drm/radeon/kms/atom: rework encoder dpms
      drm/radeon/kms: check for DP MST mode in a few more places (v2)
      drm/radeon/kms: allocate vram scratch page on 6xx+
      drm/radeon/kms: move atom encoder setup to a new file
      drm/radeon/kms: make atombios_dvo_setup() version based
      drm/radeon/kms: make atombios_dig_encoder_setup() version based
      drm/radeon/kms: make atombios_dig_transmitter_setup() version based
      drm/radeon/kms: remove useless radeon_ddc_dump()
      drm/radeon/kms: always do extended edid probe
      drm/radeon/kms: split MSI check into a separate function
      drm/radeon/kms: Add MSI quirk for HP RS690
      drm/radeon/kms: Add MSI quirk for Dell RS690
      drm/radeon/kms: add MSI module parameter
      drm/radeon/kms: set HPD polarity in hpd_init()
      drm/radeon/kms: fix DP setup on TRAVIS bridges
      drm/radeon/kms: don't poll forever if MC GDDR link training fails

Ilija Hadzic (1):
      drm/radeon/kms: use defined constants for crtc/hpd count instead
of hard-coded value 6

Jakob Bornecrantz (5):
      vmwgfx: Use pointer return error codes
      vmwgfx: Free prefered mode on error path
      vmwgfx: Unreference surface on cursor error path
      vmwgfx: Move the prefered mode first in the list
      vmwgfx: Snoop DMA transfers with non-covering sizes

Jerome Glisse (4):
      drm/radeon: avoid bouncing connector status btw disconnected & unknown
      drm/radeon: set hpd polarity at init time so hotplug detect works
      drm/radeon: flush read cache for gtt with fence on r6xx and newer GPU V3
      drm/radeon/kms: consolidate GART code, fix segfault after GPU lockup V2

Thomas Hellstrom (8):
      drm: Introduce "Virtual" connectors and encoders
      vmwgfx: Use "Virtual" connectors and encoders rather than "LVDS".
      vmwgfx: Reinstate the update_layout ioctl
      vmwgfx: Screen object cleanups
      vmwgfx: Remove screen object active list
      vmwgfx: Make the preferred autofit mode have a 60Hz vrefresh
      vmwgfx: Infrastructure for explicit placement
      vmwgfx: Fix hw cursor position

 drivers/gpu/drm/drm_crtc.c                  |    8 +-
 drivers/gpu/drm/radeon/Makefile             |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |   56 +-
 drivers/gpu/drm/radeon/atombios_dp.c        |   20 +-
 drivers/gpu/drm/radeon/atombios_encoders.c  | 2369 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/evergreen.c          |   18 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |   20 +-
 drivers/gpu/drm/radeon/ni.c                 |   25 +-
 drivers/gpu/drm/radeon/r100.c               |    7 +-
 drivers/gpu/drm/radeon/r300.c               |   16 +-
 drivers/gpu/drm/radeon/r600.c               |  106 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c      |   14 +-
 drivers/gpu/drm/radeon/radeon.h             |   57 +-
 drivers/gpu/drm/radeon/radeon_connectors.c  |   90 +-
 drivers/gpu/drm/radeon/radeon_display.c     |   36 +-
 drivers/gpu/drm/radeon/radeon_drv.c         |    4 +
 drivers/gpu/drm/radeon/radeon_encoders.c    | 2151 +------------------------
 drivers/gpu/drm/radeon/radeon_gart.c        |   71 +-
 drivers/gpu/drm/radeon/radeon_i2c.c         |   28 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c     |   60 +-
 drivers/gpu/drm/radeon/radeon_mode.h        |   14 +-
 drivers/gpu/drm/radeon/rs400.c              |    5 +-
 drivers/gpu/drm/radeon/rs600.c              |   17 +-
 drivers/gpu/drm/radeon/rv770.c              |   73 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c         |    6 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h         |    6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c         |  151 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h         |   10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c         |    5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c        |   94 +-
 include/drm/drm_dp_helper.h                 |    3 +
 include/drm/drm_mode.h                      |   12 +-
 include/drm/vmwgfx_drm.h                    |   51 +-
 33 files changed, 2948 insertions(+), 2657 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/atombios_encoders.c
