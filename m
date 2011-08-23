Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1HWO6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:58:09 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:38203 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221Ab1HWO6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:58:06 -0400
Date: Tue, 23 Aug 2011 17:58:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michal Nazarewicz <mnazarewicz@google.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
 <Pine.LNX.4.44L0.1108231030270.2069-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cf/4ySkkvY6jtT1l"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108231030270.2069-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cf/4ySkkvY6jtT1l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 10:37:23AM -0400, Alan Stern wrote:
> On Tue, 23 Aug 2011, Michal Nazarewicz wrote:
>=20
> > My understanding was that one could consciously create a composite gadg=
et
> > such that not all of the functions support all of the speeds.
>=20
> That's an important point.  If somebody wants to build a composite=20
> gadget that includes both midi and storage support, the storage driver=20
> would be able to go all the way up to SuperSpeed (or rather, it will=20
> once Felipe's patch is finished and merged) but the midi driver would=20
> only support full speed.  So what speed should the UDC connect at?

if they are both part of the of the same configuration, full speed.
Otherwise Audio won't work. If they are part of different
configurations, then maximum_speed will be defined by the chosen config,
no ?

> In cases like this there's really no way to know.  Ultimately the best=20
> approach would be to update the midi driver, but that's a long-term=20
> sort of thing.

yeah, I agree here.

> Usually when the kernel can't decide something, it asks the user for=20
> help (by allowing the user to specify the speed via a module parameter,=
=20
> for instance).  In this case even that wouldn't work, because the=20
> gadget's userspace isn't aware of which functions the host's user will=20
> want to utilize.
>=20
> At the moment I don't know the best answer.  This is something we=20
> should all think about.

I stand with the fact that if they are part of the same configuration,
there's no way around it, storage will have to come down to full speed.
Unless I'm missing something.

--=20
balbi

--Cf/4ySkkvY6jtT1l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU7/3AAoJEAv8Txj19kN1JsEIAJlttI7DMev0fORaqPkXl+2h
mOUGVUpsB2rKMPh8VIe12wPO5E8IA/uFoDd4buv4phQQcT54NxkLXAP9xljPDpQx
ekoGgyxdZnCXXkxh3dkh2eo9q2ku4k96iI+wKEWUaLiyUcwzuU2WUcO+CFSl+hg+
qxOLn2ljI3nmgYd2lVgstTJBC3m/82yLwknIDywJR3XmD+jVIOduiTpFC7IFzuEU
waFCYtVF8PG5ooLWlRRoJsa6OqMKh11rlgWmhO28zhzVPl7fjHd89jud5wUtjDcp
9hqpwlQXgE7jS/CJ0YNrKc5TUcFadIrr6XlBewmT8h+i8iUaCobPR6GIIpYTQGw=
=KC+G
-----END PGP SIGNATURE-----

--Cf/4ySkkvY6jtT1l--
