Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0CWAfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:35:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51601 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab0CWAfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:35:36 -0400
Date: Tue, 23 Mar 2010 01:35:25 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 12/24] media/video: fix dangling pointers
Message-ID: <20100323003525.GC5762@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <20100321144655.4747fd2a@hyperion.delvare> <20100321141417.GA19626@opensource.wolfsonmicro.com> <201003211709.56319.hverkuil@xs4all.nl> <20100322213358.31e50b3c@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <20100322213358.31e50b3c@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > Personally I'd much rather just not bother setting the driver data in
> > > the removal path, it seems unneeded.  I had assumed that the subsystem
> > > code cared for some reason when I saw the patch series.
> >=20
> > Anyway, should this really be necessary, then for the media drivers this
> > should be done in v4l2_device_unregister_subdev() and not in every driv=
er.
> >=20
> > But this just feels like an i2c core thing to me. After remove() is cal=
led
> > the core should just set the client data to NULL. If there are drivers =
that
> > rely on the current behavior, then those drivers should be reviewed fir=
st as
> > to the reason why they need it.
>=20
> I tend to agree, now.
>=20
> Wolfram, how do you feel about this? I feel a little sorry that I more
> or less encouraged you to submit this patch series, and now I get to
> agree with the objections which were raised against it.

Well, this is a valuable outcome in my book. Maybe seeing the actual amount=
 of
modifications necessary for cleaning up clientdata helped the process. While
working on it, I also got the impression that it should be handled differen=
tly
in the future, of course. Although I was thinking of something different
('i2c_(allocate|free)_clientdata' as mentioned before), I prefer the above
proposal as it is most simple.

> My key motivation was that I wanted i2c_set_clientdata() to be called
> before kfree(). Now that everybody seems to agree that the latter
> belongs to the drivers while the former belongs to lower layers
> (i2c-core or even driver core), this is not going to happen. So I guess
> we want to remove calls to i2c_set_clientdata(NULL) from all drivers
> and have only one in i2c-core for now?

Fine with me. Let me know if I can assist you with the series.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuoDMwACgkQD27XaX1/VRtdTQCgiT69KlXjtgYDdBqWpB7vWdkB
66gAoKYHRTMFBlDdJhGo9zOll7xKCsDD
=ngpT
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
