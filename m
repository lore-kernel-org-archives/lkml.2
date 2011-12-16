Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282Ab1LPRjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:39:11 -0500
Received: from home.keithp.com ([63.227.221.253]:57267 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab1LPRjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:39:04 -0500
From: "Keith Packard" <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] drm-intel-fixes (drm/i915 driver)
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: David Woodhouse <dwmw2@infradead.org>,
        "Garrett, Matthew" <mjg59@srcf.ucam.org>,
        Dave Airlie <airlied@linux.ie>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "drivers, Intel" <Intel-gfx@lists.freedesktop.org>
Date: Fri, 16 Dec 2011 09:39:54 -0800
Message-ID: <8662hgqutx.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


A few regression fixes:

 * eDP panels with too few lanes need 6bpc modes
 * older machine backlights going black
 * divide-by-zero crash when reading a /sys file

Quirks for a couple of machines:

 * No lvds panel on a desktop ASUS machine
 * Light up the second LVDS on the Libretto W105

Two more Ivybridge changes:

 * Use Multi-threaded force-wake where enabled by the BIOS
 * Light up eDP panels

Finally, this enables RC6 and semaphores, unconditionally on Ivybridge.
On Sandybridge, these are enabled when VTd isn't in use. We've been
wanting to do this for a long time, and instead of turning this on for
RC1 and hoping things worked out, we spent time working directly with
people who reported problems and discovered that RC6 and Semaphores
cannot be enabled when VTd is in use (even VTd for non-gfx devices).

There's a patch here which exports a value from the iommu code letting
us know when VTd is active so that RC6 and semaphores can be
disabled. That patch has been ok'd by David Woodhouse, although he's not
very happy about it. Matthew Garrett wanted to write a second patch that
disabled VTd by default on SNB machines, which would enable RC6 and
semaphores more often.

The following changes since commit f10cdea68b70bd85706baed0decab59618f9c353:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git=
/rostedt/linux-ktest (2011-11-23 09:50:42 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~keithp/linux drm-intel-fixes

Adam Jackson (2):
      drm/i915: no-lvds quirk for ASUS AT5NM10T-I
      drm/i915/dp: Dither down to 6bpc if it makes the mode fit

Chris Wilson (1):
      drm/i915/sdvo: Include LVDS panels for the IS_DIGITAL check

Eugeni Dodonov (3):
      drm/i915: prevent division by zero when asking for chipset power
      iommu: Export intel_iommu_enabled to signal when iommu is in use
      drm/i915: enable semaphores on per-device defaults

Jesse Barnes (1):
      drm/i915: don't set unpin_work if vblank_get fails

Keith Packard (4):
      drm/i915: add multi-threaded forcewake support
      drm/i915: Hook up Ivybridge eDP
      drm/i915: Treat pre-gen4 backlight duty cycle value consistently
      drm/i915: By default, enable RC6 on IVB and SNB when reasonable

Paulo Zanoni (2):
      drm/i915: set the right SDVO transcoder for CPT
      drm/i915: add PCH info to i915_capabilities

 drivers/gpu/drm/i915/i915_debugfs.c        |    1 +
 drivers/gpu/drm/i915/i915_dma.c            |   10 ++
 drivers/gpu/drm/i915/i915_drv.c            |   43 ++++++--
 drivers/gpu/drm/i915/i915_drv.h            |   18 +++-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   19 +++-
 drivers/gpu/drm/i915/i915_reg.h            |   30 ++++-
 drivers/gpu/drm/i915/intel_display.c       |   89 +++++++++++++--
 drivers/gpu/drm/i915/intel_dp.c            |  173 +++++++++++++++++++++---=
----
 drivers/gpu/drm/i915/intel_drv.h           |    1 +
 drivers/gpu/drm/i915/intel_lvds.c          |    8 ++
 drivers/gpu/drm/i915/intel_panel.c         |   16 +--
 drivers/gpu/drm/i915/intel_sdvo.c          |   36 ++++--
 drivers/iommu/intel-iommu.c                |    5 +
 include/linux/dma_remapping.h              |    2 +
 14 files changed, 361 insertions(+), 90 deletions(-)


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTuuCajYtFsjWk68qAQi3QA/+IHgaquY64cpIdGijaM5yysdNj3p3PvXc
XBZdZHxmtEIMm7wGBK0KuaXPWrTpGs7PDOS4Onq8otPGUIerMvf1FzWPT9rIMHRA
d3NzJdls9iK1+tyg3OyY+gBfPiSla7dpmmmxAOLfbFH6OujmH/TJBKKxKCqnBeWo
736DEr9Gd3LPZ4WXabnV/NCj83dPjfz4k1An2kjABk7NUkjduutURS0g7E1Rl/N7
0sZDpNyM9rp09IzVglrtDCRYjXip+KI6bPTtuQdH47s1icaLKGvQz3ViBTBaDDOh
hRsABehAi1zg+9AS4I8obHiYozZcKfx8NHjYCIWTNAtYnrBqY8NUrQZ9ztYc/th1
P4xcxBk0s9BtObZx5TFQlFDTdG9BH2p4nLnTm+QNl89egk5ZNQo1AuGD1lKV5ZJO
pEaKhhStkIvXOS34rLRybo8PBmiOleQJH0XESQamTiZfXclmhwtkiYtQEonPSINh
k89l+R6WPAny6h2505GkXfmF/yoVO3ncR5pMpAOLJcUPYI8bNjVmrf2PRp0VgwAj
NljIai5lti4HJSqTp1N3sfk4VEevu0FCiueYjLFP6QHgvohQKSOUI6ZLvFDpWZXl
8mC1uimgUnqCiBSptwyWX3/wc4aC4X1N0PdHQ/eRYGElvBlgHT8dHRfqPS07nsNc
MO5cYog4wUA=
=bVWj
-----END PGP SIGNATURE-----
--=-=-=--
