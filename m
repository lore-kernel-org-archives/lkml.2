Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1HYMxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:53:13 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:55078 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab1HYMxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:53:11 -0400
Date: Thu, 25 Aug 2011 15:53:07 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110825125306.GP22532@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1108241114270.2010-100000@iolanthe.rowland.org>
 <op.v0p439txvgw7ix@mnazarewicz-glaptop>
 <20110824230418.GA19890@legolas.emea.dhcp.ti.com>
 <op.v0rsghexvgw7ix@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FNX2SHge3qdlDajY"
Content-Disposition: inline
In-Reply-To: <op.v0rsghexvgw7ix@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FNX2SHge3qdlDajY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 25, 2011 at 02:46:55PM +0200, Michal Nazarewicz wrote:
> On Thu, 25 Aug 2011 01:04:19 +0200, Felipe Balbi <balbi@ti.com> wrote:
> >there's one catch. As of today, we always start UDCs with data pullups
> >connected, which means that we could connect to a host even before a
> >gadget driver is loaded. My point in moving to udc_start/udc_stop is
> >that the above would be take care of. See udc-core.c: [...]
>=20
> Honestly I'm not quite sure why udc_start/udc_stop is needed here.  Even
> without those the UDC driver can start with all hw disabled and turn it
> on only after the gadget driver's bind callback finishes.
>=20
> >If all UDCs are converted to udc_start()/udc_stop() we get the guarantee
> >that they will only conect to host after gadget driver is fully loaded
> >for free.
>=20
> >We can also, finally, properly use the usb_function_deactivate/
> >usb_function_activate properly. So for each registered function,
> >composite.c calls usb_function_deactivate() and function is _required_
> >to call usb_function_activate when it's ready.
>=20
> I'm not really sure why that would be beneficial.  Also, it would still
> require disconnect-connect cycle if some function decides to (de)activate
> itself while gadget is connected.
>=20
> >Then, when on gadget driver's bind() we can take this kind of speed
> >decision and pass that on to UDC driver.
>=20
> So can we leave things as they are for now and wait for UDCs to be
> converted
> and once this is done, do all kinds of magic we want in copomiset's bind
> callback?

sure.

--=20
balbi

--FNX2SHge3qdlDajY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVkWyAAoJEAv8Txj19kN1GccH/iMDIyYlImRcCP/q/EyaECxo
PPURZAlAJq86IzRquIlnBqxeMO8lu1Aw2gsC5E9HYHmfcwC83U+fplISHzHDirx5
myf6XRlV0Z+vhewibFmkkmFGsJvdfkB+Ux0PqEEPVxvy37XFO2bktBuvVr0r32Mc
WaSuHjPYPzXUdrv6sxLcck9Dba12ZVRMDNy2i5A7Qyi+UWNgPL8fIu36Luj/N2Oo
LvzW5Rz8LYpQ6cqM12AUDnVpaQpE/9PNrkX1L5oaVPbvHU8+HPHZpQpsik/PoyHQ
t3GWSJNPFtSbKScnylVnfBVavlaYSb+xdtnVsvmGchj1zQyXj5vTLD/X9KADk30=
=UxIv
-----END PGP SIGNATURE-----

--FNX2SHge3qdlDajY--
