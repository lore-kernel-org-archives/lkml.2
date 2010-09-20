Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0ITX54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:57:56 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:47178 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab0ITX5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:57:55 -0400
From: Eric Anholt <eric@anholt.net>
To: Jan Beulich <JBeulich@novell.com>
Cc: Brice.Goglin@ens-lyon.org, airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: agp/intel: Fix the pre-9xx chipset flush
In-Reply-To: <4C922C700200007800016CB4@vpn.id2.novell.com>
References: <4C922C700200007800016CB4@vpn.id2.novell.com>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 20 Sep 2010 16:57:45 -0700
Message-ID: <871v8oufwm.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Sep 2010 13:40:48 +0100, "Jan Beulich" <JBeulich@novell.com> wro=
te:
> Eric,
>=20
> in this patch you removed from intel_i830_setup_flush() a call to
> map_page_into_agp(), but you left in place the counterpart call from
> intel_i830_fini_flush() to unmap_page_from_agp()? Isn't it mere luck
> that on x86 this is only a call to set_pages_wb()?

Sounds like just an oversight.

> Further, is there really a point in doing the respective allocation
> with GFP_DMA32? Nor does __GFP_ZERO seem really necessary...

The hardware in question doesn't have memory above 32 bits, so either
way doesn't matter much.  Yeah, GFP_ZERO doesn't seem needed.

If you've got patches for agp, Chris Wilson's the kernel module
maintainer now, and Daniel Vetter's got a huge changeset queued to -next
to clean up the disaster that is the "agp" code for integrated graphics.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyX9PkACgkQHUdvYGzw6vc9WwCeIpOUXgQ3dsij8QSPDOnM0jID
LL8AoIuCfN9mFtDiPC43BZzyGUMET5cG
=9Fdg
-----END PGP SIGNATURE-----
--=-=-=--
