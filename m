Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1H2Pj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:39:56 -0400
Received: from home.keithp.com ([63.227.221.253]:45981 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab1H2Pjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:39:54 -0400
From: Keith Packard <keithp@keithp.com>
To: Pawel Sikora <pluto@agmk.net>, linux-kernel@vger.kernel.org
Cc: kamal@canonical.com
Subject: Re: Linux 3.1-rc4
In-Reply-To: <2352775.A2sX9R5EWV@pawels>
References: <2352775.A2sX9R5EWV@pawels>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 29 Aug 2011 08:39:46 -0700
Message-ID: <yun8vqccjlp.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Aug 2011 15:22:10 +0200, Pawel Sikora <pluto@agmk.net> wrote:
> Hi,
>=20
> the recent -rc4 fix ( Kamal Mostafa / i915: do not setup intel_backlight =
twice ) fixes an oops
> described in https://bugzilla.kernel.org/show_bug.cgi?id=3D40892#c1 but t=
he core error
> "[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed" still
> exists.

That looks harmless; I'll check with the ACPI experts though.

> Aug 29 15:10:55 vmx kernel: [22761.103401] BUG: unable to handle kernel p=
aging request at 000000104a69c2f8
> Aug 29 15:10:55 vmx kernel: [22761.103403] IP: [<ffffffff81265d02>] fb_fl=
ashcursor+0x42/0x150

I'm assuming this is a regression; can you find a version that it worked
on without any other changes in the environment? I'm concerned that
you're loading both vesafb and then switching to the drm fb, which
always seems fraught with peril to me.

And, of course, a bisect would be most helpful if possible. I can't
think of any i915-specific changes that would cause fb mappings to go wrong.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOW7LCQp8BWwlsTdMRAhLkAJ9iYXJGwVan6kSN91enB72uTBISPACfe5Bc
s5CTbi9PG+JUCVkihUrbfjQ=
=7EiT
-----END PGP SIGNATURE-----
--=-=-=--
