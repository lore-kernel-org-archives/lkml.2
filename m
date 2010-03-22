Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0CVNxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:53:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51173 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab0CVNxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DdAhxUwz+Yv9WcFAV0nHbxrzEUExhxR6DGVX2rIaL1O3wB1uA5NUPZJUQi554tGgNm
         GbkQFbUoH/vcvjAd4vogC8o7cLRWYkoY3nSoPNWRryMMOIeUvAGbZ/IJyOrhDOT3wvw/
         QFSH/OeGS+Owq0BRyKd8Fx0oC9js8UVVFGOTc=
Date: Mon, 22 Mar 2010 15:54:01 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lin Ming <ming.m.lin@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] Fix key f70f4b50 not in .data in thermal_sys
Message-ID: <20100322135401.GB3388@swordfish.minsk.epam.com>
References: <20100309102754.GA3316@swordfish.minsk.epam.com>
 <20100309141826.GC28606@suse.de>
 <20100322131508.GB3596@swordfish.minsk.epam.com>
 <20100322133138.GA1076@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <20100322133138.GA1076@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
Wolfram you are 100% right. My first patch didn't solve the problem.
Please see v2.

	Sergey


On (03/22/10 14:31), Wolfram Sang wrote:
> On Mon, Mar 22, 2010 at 03:15:08PM +0200, Sergey Senozhatsky wrote:
> > Initialize sysfs attributes before device_create_file call.
> >=20
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> >=20
> > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sy=
s.c
> > index 5066de5..a76a6ff 100644
> > --- a/drivers/thermal/thermal_sys.c
> > +++ b/drivers/thermal/thermal_sys.c
> > @@ -492,6 +492,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device =
*tz)
> >  		goto free_mem;
> >  	}
> >  	dev_set_drvdata(hwmon->device, hwmon);
> > +	sysfs_attr_init(&dev_attr_name.attr);
> >  	result =3D device_create_file(hwmon->device, &dev_attr_name);
>=20
> This one should not be needed? Is declared static in line 426.
>=20
> >  	if (result)
> >  		goto unregister_hwmon_device;
> > @@ -505,6 +506,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device =
*tz)
> >  	tz->temp_input.attr.attr.name =3D tz->temp_input.name;
> >  	tz->temp_input.attr.attr.mode =3D 0444;
> >  	tz->temp_input.attr.show =3D temp_input_show;
> > +	sysfs_attr_init(&tz->temp_input.attr.attr);
> >  	result =3D device_create_file(hwmon->device, &tz->temp_input.attr);
> >  	if (result)
> >  		goto unregister_hwmon_device;
> > @@ -517,6 +519,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device =
*tz)
> >  			tz->temp_crit.attr.attr.name =3D tz->temp_crit.name;
> >  			tz->temp_crit.attr.attr.mode =3D 0444;
> >  			tz->temp_crit.attr.show =3D temp_crit_show;
> > +			sysfs_attr_init(&tz->temp_crit.attr.attr);
>=20
> Those encapsuled attributes are trickier to find, sigh...
>=20
> Regards,
>=20
>    Wolfram
>=20

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkundnkACgkQfKHnntdSXjShVAP/TdKimkeJJlevX5RabkkqNULc
ARkECjXNcvySFrzIkPDtin2G6NRlXIcvVdFlqh+YsgDLoNdEDmkuYpMg7oI+VgTt
o32aAs1nDWURo7TQf9T5QLmGPAYstc0A2AjIR0Wpa/yfjAo/y5DeidNuWumu4dlk
VS4lfr4W63/h04YJY40=
=dqkS
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
