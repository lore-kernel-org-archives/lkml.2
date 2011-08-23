Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1HWPLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:11:19 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:53147 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764Ab1HWPLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:11:12 -0400
Date: Tue, 23 Aug 2011 18:11:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110823151105.GP1341@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
 <Pine.LNX.4.44L0.1108231030270.2069-100000@iolanthe.rowland.org>
 <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
 <op.v0n9l9h9vgw7ix@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NEAjDeynQrrxd8+d"
Content-Disposition: inline
In-Reply-To: <op.v0n9l9h9vgw7ix@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NEAjDeynQrrxd8+d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 05:07:11PM +0200, Michal Nazarewicz wrote:
> On Tue, 23 Aug 2011 16:58:01 +0200, Felipe Balbi <balbi@ti.com> wrote:
> >I stand with the fact that if they are part of the same configuration,
> >there's no way around it, storage will have to come down to full speed.
> >Unless I'm missing something.
>=20
> If you look at config_buf() in composite.c, you'll notice that composite
> just skips functions that do not support current speed.  This means, that
> if a connection uses high speed but given function can handle only full
> speed, it won't be included in the descriptors.
>=20
> config_buf() is called from config_desc() which similarly, iterates over
> configurations skipping the ones that do not support given speed.
>=20
> Configuration is defined to support given speed if at least one function
> that is added to that configuration supports that speed (see
> usb_add_function()).

I'm trying to think if this is really what we want. This might mean
$current_config will be different depending if we connect it to SS, HS
or FS hubs. Do we need USB-IF's help here ? I guess I could drop them a
mail and ask for some clarification. Don't know how long it would take
to get an answer though :-s

--=20
balbi

--NEAjDeynQrrxd8+d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU8MJAAoJEAv8Txj19kN1jSsH/2UW7WxGfDOP68aZ5fT5VYrf
iyWmbKdL1thDYL4Lnx8xhF/Ibvy5O2ELeS5uzqOprEPFhylcDlLheVmMPir7I13K
BNFlDLOXQwNvhR2CCAO7eLJYDHI2PcYKPofnvQH3pbzOsDmWlCqBNHnpc0p4mFAa
4Xr1zaOx+VVEPTiRC3oEjMxtSeqWdTngl+JIRQZ/CUwZuxOP/oXa3tWdVq4AmBCh
YVCw/8V7xUaBsWWDcsewoZADEinKusmZLVAak70NWRQ4IGTneko5PKrjv6rzMbQm
ykCkE38mELZqaEBYxal/fg5O1wlCHY9gg225/tYmm2u+ProED5nb8vU8jK8hcC0=
=h8Wz
-----END PGP SIGNATURE-----

--NEAjDeynQrrxd8+d--
