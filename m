Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab0DVV6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:58:50 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:56067 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0DVV6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:58:48 -0400
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel fixes for 2.6.34-rc4
Date: Thu, 22 Apr 2010 14:58:22 -0700
Message-ID: <87hbn3kv41.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

The following changes since commit 13bd8e4673d527a9e48f41956b11d391e7c2cfe0:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../anholt/drm-intel

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

I hear you've got an Ironlake laptop. If so, it's time to get excited.
The interrupt wedging fix is here.

The docs since the original gen4 have said "stop using
MI_STORE_DWORD_INDEX+MI_USER_INTERRUPT, it's not guaranteed to be
ordered, so use the fancy new PIPE_CONTROL."  I was thinking that
ignoring this might be the problem with our interrupts.  So jbarnes
tried it, and it made things hang even faster.  Then Zhenyu found an
errata: Pipe control doesn't have working ordering on Ironlake, so do it
twice, with 6 dummy PIPE_CONTROLs in between.

GPUs are awesome.

Adam Jackson (2):
      drm/i915: Attempt to fix watermark setup on 85x (v2)
      drm/i915: Fix 82854 PCI ID, and treat it like other 85X

Daniel Vetter (1):
      drm/i915: fix tiling limits for i915 class hw v2

Jesse Barnes (2):
      drm/i915: cleanup FBC buffers at unload time
      drm/i915: use PIPE_CONTROL instruction on Ironlake and Sandy Bridge

Zhang Rui (1):
      drm/i915: set DIDL using the ACPI video output device _ADR method return.

 drivers/gpu/drm/i915/i915_dma.c        |   14 +++
 drivers/gpu/drm/i915/i915_drv.c        |    5 +-
 drivers/gpu/drm/i915/i915_drv.h        |   10 ++-
 drivers/gpu/drm/i915/i915_gem.c        |  151 +++++++++++++++++++++++++++++---
 drivers/gpu/drm/i915/i915_gem_tiling.c |   22 ++---
 drivers/gpu/drm/i915/i915_irq.c        |    8 +-
 drivers/gpu/drm/i915/i915_opregion.c   |   54 +++++++++++-
 drivers/gpu/drm/i915/i915_reg.h        |   13 +++-
 drivers/gpu/drm/i915/intel_display.c   |   11 ++-
 9 files changed, 246 insertions(+), 42 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvQxn4ACgkQHUdvYGzw6vf3twCghI4C/h2kSzylRDFtgIIPzOAS
69cAn1Wv3yRoXwsEpaxbXK9b/ZxvFtRM
=CM7/
-----END PGP SIGNATURE-----
--=-=-=--
