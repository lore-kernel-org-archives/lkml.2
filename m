Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab1F3DyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 23:54:08 -0400
Received: from home.keithp.com ([63.227.221.253]:38222 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1F3Dx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 23:53:58 -0400
From: Keith Packard <keithp@keithp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Cc: kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it can't shrink any objects
In-Reply-To: <4E0444CA.3080407@jp.fujitsu.com>
References: <4E0444CA.3080407@jp.fujitsu.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 29 Jun 2011 20:53:54 -0700
Message-ID: <yuny60kt1nx.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Jun 2011 17:03:22 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fuj=
itsu.com> wrote:

> Now, i915_gem_inactive_shrink() should return -1 instead of 0 if it
> can't take a lock. Otherwise, vmscan is getting a lot of confusing
> because vmscan can't distinguish "can't take a lock temporary" and
> "we've shrank all of i915 objects".

This doesn't look like the cleanest change possible. I think it would be
better if the shrink function could uniformly return an error
indication so that we wouldn't need the weird looking conditional return.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOC/NSQp8BWwlsTdMRAq6kAKC37VK0s8iStNIdRcbNH91FMuRBVwCeJZBj
hdXPK/VpZKPNnBtMgzDIpbQ=
=D8Nq
-----END PGP SIGNATURE-----
--=-=-=--
