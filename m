Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0FAVMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:12:46 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:49935 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab0FAVMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:12:43 -0400
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel changes for 2.6.35-rc1
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Tue, 01 Jun 2010 14:12:33 -0700
Message-ID: <871vcqihj2.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

The following changes since commit 63a6440326e4cd01d6a663069208a0e68e9b833f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus (2010-05-26 08:57:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-next

There is a big change here that hadn't quite made it through enough
review for airlied's pull before rc1.  I think we're ready, though, and
it's a pretty big feature deal: h.264 acceleration on Ironlake hardware.
Also in here is the IPS cooperation needed for massive speedups of
graphics on Ironlake.

Adam Jackson (4):
      drm/i915/gen4: Extra CRT hotplug paranoia
      drm/i915/dp: Only enable enhanced framing if the sink supports it
      drm/i915/dp: Add DPCD data to debug output
      drm/i915: Honor sync polarity from VBT panel timing descriptors

Chris Wilson (17):
      drm/i915: Fail to load driver if KMS request without GEM
      agp/intel: Restrict GTT mapping to valid range on i915 and i945
      drm/i915: Kill dangerous pending-flip debugging
      drm/i915: Only print an message if there was an error
      drm/i915: Hold the spinlock whilst resetting unpin_work along error path
      drm/i915: Avoid nesting of domain changes when setting display plane
      drm/i915: Propagate error from unbinding an unfenceable object.
      drm/i915: Only print "nothing to do" debug message as required.
      drm/i915: Include pitch in set_base debug statement.
      drm/i915: Rebind bo if currently bound with incorrect alignment.
      drm/i915: Remove spurious warning "Failure to install fence"
      drm/i915: Check error code whilst moving buffer to GTT domain.
      drm/i915: Reject bind_to_gtt() early if object > aperture
      drm/i915: Cleanup after failed initialization of ringbuffers
      drm/i915: Avoid moving from CPU domain during pwrite
      drm/i915: Use non-atomic kmap for slow copy paths
      drm/i915: Fix up address spaces in slow_kernel_write()

Dan Carpenter (2):
      i915/intel_sdvo: remove unneeded null check
      i915: remove unneeded null checks

Daniel J Blueman (1):
      i915: fix lock imbalance on error path...

Daniel Vetter (1):
      drm/i915: combine all small integers into one single bitfield

Eric Anholt (3):
      drm/i915: Move ringbuffer-related code to intel_ringbuffer.c.
      drm/i915: Rename dev_priv->ring to dev_priv->render_ring.
      drm/i915: Clean up leftover bits from hws move to ring structure.

Jesse Barnes (2):
      drm/i915: add timeout to FBC disable waits
      drm/i915: add power monitoring support

Krzysztof Halasa (1):
      drm/i915: Add support for interlaced display.

Li Peng (1):
      drm/i915: Add CxSR support on Pineview DDR3

Li Zefan (1):
      drm/i915: Convert more trace events to DEFINE_EVENT

Tobias Klauser (1):
      drm/i915: Storage class should be before const qualifier

Zhenyu Wang (3):
      drm/i915: Fix HDMI mode select for Cougarpoint PCH
      drm/i915: Fix PIPE_CONTROL command on Sandybridge
      drm/i915: Unmask interrupt for render engine on Sandybridge

Zou Nan hai (4):
      drm/i915: introduce intel_ring_buffer structure (V2)
      drm/i915: convert some gem structures to per-ring V2
      drm/i915: implement BSD ring buffer V2
      drm/i915: add HAS_BSD check to i915_getparam

 drivers/char/agp/intel-gtt.c            |   46 ++-
 drivers/gpu/drm/i915/Makefile           |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c     |   82 +++-
 drivers/gpu/drm/i915/i915_dma.c         |  711 ++++++++++++++++++++-----
 drivers/gpu/drm/i915/i915_drv.c         |   70 +--
 drivers/gpu/drm/i915/i915_drv.h         |  209 ++++----
 drivers/gpu/drm/i915/i915_gem.c         |  897 ++++++++++++-------------------
 drivers/gpu/drm/i915/i915_irq.c         |  182 +++----
 drivers/gpu/drm/i915/i915_reg.h         |   82 +++-
 drivers/gpu/drm/i915/i915_trace.h       |   24 +-
 drivers/gpu/drm/i915/intel_bios.c       |   10 +
 drivers/gpu/drm/i915/intel_crt.c        |   23 +-
 drivers/gpu/drm/i915/intel_display.c    |  281 ++++++++---
 drivers/gpu/drm/i915/intel_dp.c         |   11 +-
 drivers/gpu/drm/i915/intel_fb.c         |    6 +-
 drivers/gpu/drm/i915/intel_hdmi.c       |    5 +-
 drivers/gpu/drm/i915/intel_overlay.c    |   52 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c |  849 +++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_ringbuffer.h |  124 +++++
 drivers/gpu/drm/i915/intel_sdvo.c       |    2 +-
 include/drm/i915_drm.h                  |    5 +-
 21 files changed, 2590 insertions(+), 1082 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/intel_ringbuffer.c
 create mode 100644 drivers/gpu/drm/i915/intel_ringbuffer.h

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwFd8EACgkQHUdvYGzw6vd7+gCeIZR1k6jqfwHJsxHE7Db3lN1W
7kQAoIQOwECxNgVgpzZyy/5sVQzBS5zH
=43lo
-----END PGP SIGNATURE-----
--=-=-=--
