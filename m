Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935780Ab1JFJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 05:27:16 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:42593 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932475Ab1JFJ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 05:27:15 -0400
Date: Thu, 6 Oct 2011 12:27:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20111006092708.GC1714@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1314364322.git.mina86@mina86.com>
 <befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
 <op.v1joh7yevgw7ix@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <op.v1joh7yevgw7ix@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 09, 2011 at 04:14:21PM +0200, Michal Nazarewicz wrote:
> On Fri, 26 Aug 2011 15:18:35 +0200, Michal Nazarewicz
> <mnazarewicz@google.com> wrote:
> >This commit replaces usb_gadget's is_dualspeed field with
> >a max_speed field.
> >---
> >
> >I was unable to figure out how to create a symlink in
> >non-race-condition way so for now I've created both speed and
> >current_speed attributes.  This needs to get fixed before getting
> >merged.
> >
> >I would even consider just removing speed since udc-core got merged
> >only in 3.1, so maybe it won't be such a big issue?
>=20
> I've dug a bit deeper and could not find *any* way of creating the
> speed -> current_speed symlink.  sysfs_create_link() requires target
> to be an kobject and as far as I can see attributes don't have one.
>=20
> So I see the following possibilities:
>=20
> 1. Leave speed only (as Felipe noticed, this may be confusing for
>    users since there will be "speed" and "maximum_speed").
> 2. Rename it to current_speed without transition period (udc-core is
>    young so maybe no one will notice, but that won't be very nice).

let's use current_speed without the grace period.

--=20
balbi

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjXRsAAoJEAv8Txj19kN1Sp8H/12NUQenr1YxcD3m/cKSHWou
JQHJyeuyIpzo12CkJFIB9nVvszJnZHO9hZITT3AA3sCXPWWtl1n4D7hTZ2r+m5Wr
8DyYRl9dTwxNR+ze0Y6AdH4267ElGXDfyXGLWJnUOPj7j0y/IC26GflmTipkjGZn
URy/G9cTTw1LzEZ6DXGXIQOd4RaLcfYbRm40Qev19e7YyB8E3iLR0SSsp6wVwrJv
/eSXKz3yjaIYLDDEuCHOD7rGegeUur9FXCCcjt2PT5+q3QBxUJDEjJxUjhAciPSd
GLUi8MqXVYH3G115sAWd2ko6ECESFAVP1ha0WHzUUftdIUcwSEXfCLN0oS6Zrc4=
=U0ve
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--
