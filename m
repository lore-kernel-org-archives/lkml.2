Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab0GAWkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:40:05 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:45741 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293Ab0GAWj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:39:59 -0400
From: Eric Anholt <eric@anholt.net>
To: Dan Carpenter <error27@gmail.com>, David Airlie <airlied@linux.ie>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, nanhai.zou@intel.com,
       Benny Halevy <bhalevy@panasas.com>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] i915: take struct_mutex in i915_dma_cleanup()
In-Reply-To: <20100623111954.GA16433@bicker>
References: <20100623111954.GA16433@bicker>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Thu, 01 Jul 2010 15:39:57 -0700
Message-ID: <87fx0225du.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Jun 2010 13:19:55 +0200, Dan Carpenter <error27@gmail.com> wrote:
> intel_cleanup_ring_buffer() calls drm_gem_object_unreference() (as
> opposed to drm_gem_object_unreference_unlocked()) so it needs to be
> called with "struct_mutex" held.  If we don't hold the lock, it triggers
> a BUG_ON(!mutex_is_locked(&dev->struct_mutex));
>=20
> I also audited the other places that call intel_cleanup_ring_buffer()
> and they all hold the lock so they're OK.
>=20
> This was introduced in: 8187a2b70e3 "drm/i915: introduce
> intel_ring_buffer structure (V2)" and it's a regression from v2.6.34.
>=20
> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=3D16247
>=20
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Reported-by: Benny Halevy <bhalevy@panasas.com>
> Tested-by: Benny Halevy <bhalevy@panasas.com>

Applied to for-linus.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwtGT0ACgkQHUdvYGzw6vfJPgCfentvhj0aYdeqE4E/aVq7yRVB
G/AAn3M8Z47jmFAiDN47s9UwKhmv05PU
=akqV
-----END PGP SIGNATURE-----
--=-=-=--
