Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0CYIzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:55:00 -0400
Received: from vps.mortis.eu ([79.99.135.181]:41180 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0CYIy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:54:56 -0400
Date: Thu, 25 Mar 2010 09:54:50 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for
 F71808E and F71889
Message-ID: <20100325085450.GA20126@salidar.me.mortis.eu>
References: <20100323141718.GA23172@salidar.me.mortis.eu>
 <1269385936-3440-1-git-send-email-me@mortis.eu>
 <1269385936-3440-2-git-send-email-me@mortis.eu>
 <1269385936-3440-3-git-send-email-me@mortis.eu>
 <1269385936-3440-4-git-send-email-me@mortis.eu>
 <4BA9CF57.4030504@redhat.com>
 <20100324093651.GG6368@salidar.me.mortis.eu>
 <4BA9EA5C.9060506@redhat.com>
 <20100324153550.GK6368@salidar.me.mortis.eu>
 <20100324155151.2482952f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20100324155151.2482952f@lxorguk.ukuu.org.uk>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 24, 2010 at 03:51:51PM +0000, Alan Cox wrote:
>> hold on the SIO port range. This would thus interfere with the
>> operation of the f71882fg driver. I.e. it would prevent the device
>> probing stage from working, thus preventing it from loading *after*
>> my in-development watchdog driver.
>=20
> There are two ways to deal with that really
>=20
> ... snip ...
>
> 2. Fix the kernel request_resource stuff to support a sleeping non
> exclusive resource so request/free of regions can be used as a resource
> semaphore by co-operative devices.
>=20
> #2 is actually not hard but when I did the patch originally it then
> wasn't needed by the driver I had in mind for other reasons.
>=20
> See http://groups.google.com/group/linux.kernel/msg/1425fc2aad32e6ea
>=20
> Maybe its worth resurrecting ?

In this particular case I most definitely think it's worth resurrecting.
Using your patch (I had to change the IORESOURCE_MUXED constant's value
though) I can completely solve the I/O sharing issue for the f71882fg +
watchdog case with only a single line modification to the f71882fg
driver.

One question regarding your patch though: how will it function when
driver (A) locks an I/O region using request_region() then driver (B)
comes along and tries to lock it using request_muxed_region()? One
problem I imagine might occur is that driver (A)'s 'struct resource'
doesn't have the IORESOURCE_MUXED flags set, thus simply won't wake up
driver (B) on the 'muxed_resource_wait' queue.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkurJNkACgkQZBYm/87l50LCpQCcCz02vI1neFJtEuPRdB6ww2+g
fLoAn1wxVYYtHcVKpPtx/xWnrSm6tpew
=BApW
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
