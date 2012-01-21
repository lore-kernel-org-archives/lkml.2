Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab2AUScO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:32:14 -0500
Received: from home.keithp.com ([63.227.221.253]:39317 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab2AUScN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:32:13 -0500
From: Keith Packard <keithp@keithp.com>
To: Chris Diamand <chris.diamand@gmail.com>, linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, melchior.franz@gmail.com
Subject: Re: i915/kms/backlight-combo mode problem (was: Re: Linux 2.6.39-rc5)
In-Reply-To: <4F1AF145.2090407@gmail.com>
References: <4F1AF145.2090407@gmail.com>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 21 Jan 2012 10:32:09 -0800
Message-ID: <86k44kkity.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 17:09:25 +0000, Chris Diamand <chris.diamand@gmail.com>=
 wrote:
> Hi,
>=20
> I have the problem described in the thread here=20
> (https://lkml.org/lkml/2011/4/29/217) where the backlight
> values are reversed so although stuff is displayed on the screen, the=20
> backlight is off. This occurs with kernels from about 2.6.39 onwards.
>=20
> After booting a "broken" kernel (>~2.6.39), the backlight can be lit=20
> temporarily with:
> setpci -s 00:02.0 F4.B=3D0
> and then turned off with:
> setpci -s 00:02.0 F4.B=3DFF

Can you experiment with other values? I'd like to know if it's
completely reversed, or if there's some other interaction here.

Testing 0x80, 0x7f, 0x01, 0xfe would all be interesting to me.

I suspect that writes to the LPBC value are being trapped by SMI and
'doing things' underneath.

> Yesterday I tried this patch, https://lkml.org/lkml/2011/4/30/37 by=20
> manually applying it to the 3.2.1
> kernel source - this fixes the problem.

Can you still turn the backlight off with this patch in place?

> ** Unfortunately the LKML thread stops after this patch and given that=20
> the problem is still present in the latest source, this code wasn't=20
> pushed into the kernel. Is there a reason for this or was it just=20
> forgotten about? What can I do about this? I am happy to make a git=20
> patch with the latest source if this will help.

The patch would completely bypass LPBC-based brightness controls if the
backlight happened to be off when the driver started, which isn't
exactly what you want.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxsEqTYtFsjWk68qAQhHPA//StQgVhot3xfgkQUTqQn8ASjZ4Xjdwx4B
MbIb7A/oE5ZFSrUTYiGE33YPODxwU81Prj38HENujFMpqeZiMeLmn5zm8zNVfPqV
XO00gD/me1rILG4raneQnHuVTR9C/UqB2PzlZGzatIOYHtMRjvCqTTyI+fAGJzMF
bRwLS6YjYvVE11PvRb2a3Ned3LihJ2nOkNkh6/xUCACaMrtDqNNOT5wI2wTc8xIQ
G8zKC9vZcVHRgHalBQgea+BOv0k31zBcOlvx3+jzkOxWcXml6LltidMWA791s8zP
NcHr/rZUgZ0fB8+tt4rd/2d370U+7d+F+BI+QJP9dPk3iXOuzXQaizNrhyB8RIHJ
2gEgSWlWUtXh7+yCTm8m1uAlRkV9CxrDWVMg101NjZplYnxBGXT96gISU2/Jg/Bm
tTQX+AGlrPcOhQiHAEi/97NLNv0c226UpoJrq9QTsKKRVFnIAhD8vVG1aFY42s52
6kBn1qz1EI8wvpxiU8kkq3YHS6f2B8rrt7Xkv0r8srlrzWiPjQVGjCxEFllxaOZ6
hQZDm6tY/r8HrHriVZSAvjAlq/sRSXUdQIpOII1+e8dGdzbLKYH0yZzCng/JhGqh
VafpXizh8MJetqX302cD54Ls+vmrQh7uj0dMFGdvkdnHJ8PytAlhX9xH2vuJA71m
+vGD+cij0pg=
=Ev+E
-----END PGP SIGNATURE-----
--=-=-=--
