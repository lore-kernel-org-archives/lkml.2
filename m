Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1GLR6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:58:12 -0400
Received: from home.keithp.com ([63.227.221.253]:45360 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab1GLR6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:58:10 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes (drm/i915 driver)
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 12 Jul 2011 10:58:03 -0700
Message-ID: <yun7h7ne5zo.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


What have we got here:=20

 * A list of DP fixes from Jesse to make the code conform more closely
   to the specification.

 * Making Ivybridge use the Sandybridge GPU reset path.

 * Recover from i915 load failure without causing a later panic
   when the shrinker ran.

 * Revert the RC6 enable patch -- there are at least two machines which
   mysteriously fail with RC6 enabled. We found lots of possible causes,
   none of which appear to help these last few hold-outs.

 * Fix an obvious typo -- the GPU idling code was using the wrong variable
   for the size of the ring. This may well cause spurious suspend
   failures as the GPU wouldn't have been reliably idled.

The following changes since commit fe0d42203cb5616eeff68b14576a0f7e2dd56625:

  Linux 3.0-rc6 (2011-07-04 15:56:24 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-fixes

Chris Wilson (1):
      drm/i915/ringbuffer: Idling requires waiting for the ring to be empty

Jesse Barnes (7):
      drm/i915/dp: retry link status read 3 times on failure
      drm/i915/dp: use DP DPCD defines when looking at DPCD values
      drm/i915/dp: read more receiver capability bits on hotplug
      drm/i915/dp: try to read receiver capabilities 3 times when detecting
      drm/i915/dp: remove DPMS mode tracking from DP
      drm/i915/dp: consolidate AUX retry code
      drm/i915/dp: manage sink power state if possible

Keith Packard (2):
      drm/i915: Clean up i915_driver_load failure path
      Revert "drm/i915: enable rc6 by default"

Kenneth Graunke (1):
      drm/i915: Enable GPU reset on Ivybridge.

 drivers/gpu/drm/i915/i915_dma.c         |   14 +++-
 drivers/gpu/drm/i915/i915_drv.c         |    3 +-
 drivers/gpu/drm/i915/intel_dp.c         |  118 ++++++++++++++++++++++++---=
----
 drivers/gpu/drm/i915/intel_ringbuffer.h |    2 +-
 4 files changed, 105 insertions(+), 32 deletions(-)


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOHIsrQp8BWwlsTdMRAuIcAKCpq+OqPsAebJsdmAAplBz6bJ5VnQCgzzuP
bP+AYNsIon6UiJnXGZ3O6hE=
=obA4
-----END PGP SIGNATURE-----
--=-=-=--
