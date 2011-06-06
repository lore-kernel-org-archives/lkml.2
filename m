Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1FFLSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:18:05 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36812 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab1FFLSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:18:02 -0400
Date: Mon, 6 Jun 2011 14:17:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 4/9] usb: Add max_speed to usb_composite_driver
 structure
Message-ID: <20110606111755.GV18731@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306847914-19876-1-git-send-email-tlinder@codeaurora.org>
 <1306847914-19876-5-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e1+sTVyxRliB/aPL"
Content-Disposition: inline
In-Reply-To: <1306847914-19876-5-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e1+sTVyxRliB/aPL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 31, 2011 at 04:18:24PM +0300, Tatyana Brokhman wrote:
> This field is used by the Gadget drivers to specify the maximum speed
> they support, meaning: the maximum speed they can provide descriptors for.
>=20
> The driver speed will be set in consideration of this value.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

personally, I don't think this is good enough. The gadget speed is
actually the min() of the f_* speeds. So, IMHO this should be coming
=66rom f_* and during bind you would:

gadget->speed =3D min(f->speed, gadget->speed);

for all functions. Also, both this patch and what I described above,
only works considering nobody touches that enum, so we might want to be
careful and add some comments to the enum to avoid anyone from touching
that :-)

--=20
balbi

--e1+sTVyxRliB/aPL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7LdjAAoJEAv8Txj19kN1gG4H/jXnTqdlgV4dbY5h/SodSral
LRu2JhvGpmNaKIhQIw0Vth4A3eara9L2FD0UEhEVMXvQo8U2vGaIS4x3Ei0VFaA3
vV/HSorO7RN3GuXyGOc9VLAEEjW5ylHecH65qghYoGvcF8v1eWPds9KmZBh/uM4y
1CoZ2wjwbpaFv2A9VVs+8mD/leuKjS/sdVu7zZmOpzI1YUGZMJu1cHWynIg55Kdd
paSKuv/xeM9bbdPVngqKp5ip8eI0I3mvT+b2fogvhaJvumiZ4kpP3qNIPhI5vYKC
41nsFG18UvC91QGyHZwj1IsmmoYzNK+kS6K0JdWHURghTeZlVTSkYhbVm9Gvi9I=
=JLNv
-----END PGP SIGNATURE-----

--e1+sTVyxRliB/aPL--
