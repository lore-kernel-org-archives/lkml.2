Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2KPVe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:34:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2KPVe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:34:26 -0500
Date: Fri, 16 Nov 2012 22:34:21 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: Add of_find_backlight_by_node() function
Message-ID: <20121116213420.GA27563@avionic-0098.mockup.avionic-design.de>
References: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
 <20121116131645.c979837c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20121116131645.c979837c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:X6JxoAD3HVswODribNDsgf+tVfyDZyD857p9V8pRKFF
 ya476T7DlERtkwBfsS+gHAupWgHcEZcDjwfZ86gg1RXMQZYWPM
 Mcvjjm5DrHDRViilgWIhYYz5pmBWhs6HKMrgjLAGIn563+jB2h
 ecsZUh9+Vo2260X7T+MQvIjBqRfDOtaKt3xef1275RwJmDK/SC
 gGcV1MIJtgR6g2zM89QCTme4Vm2SBxefKI6pw/5hiWAPCMZ2WC
 j779/WCZD9BR/DJJxV1v1sIymOX4mT942voQJZi0xPRKUQPCv5
 uPc8X3mf2GWVnbkGgZdynt1D009OtR1arTwvkr2HzQpvI0/WVS
 /iA0XWZ9yPG+XMgOSkm/h6wEEZfKDkh7L3K2TIfJaHQ2vU+RPh
 PksJDwn1PsQ4ZOBs0Uctt+XxgY8+YImhn0uRl7JMl6pJN0GqgM
 BKpcK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 01:16:45PM -0800, Andrew Morton wrote:
> On Fri,  9 Nov 2012 15:04:38 +0100
> Thierry Reding <thierry.reding@avionic-design.de> wrote:
>=20
> > This function finds the struct backlight_device for a given device tree
> > node. A dummy function is provided so that it safely compiles out if OF
> > support is disabled.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  drivers/video/backlight/backlight.c | 17 +++++++++++++++++
> >  include/linux/backlight.h           | 10 ++++++++++
> >  2 files changed, 27 insertions(+)
> >=20
> > diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backli=
ght/backlight.c
> > index 297db2f..0d1ed4f 100644
> > --- a/drivers/video/backlight/backlight.c
> > +++ b/drivers/video/backlight/backlight.c
> > @@ -370,6 +370,23 @@ void backlight_device_unregister(struct backlight_=
device *bd)
> >  }
> >  EXPORT_SYMBOL(backlight_device_unregister);
> > =20
> > +#if IS_ENABLED(CONFIG_OF)
>=20
> Using IS_ENABLED() was odd.  We'll never support CONFIG_OF=3Dm, so can't
> we use plain old "#ifdef CONFIG_OF" here?
>=20
> --- a/drivers/video/backlight/backlight.c~backlight-add-of_find_backlight=
_by_node-function-fix
> +++ a/drivers/video/backlight/backlight.c
> @@ -370,7 +370,7 @@ void backlight_device_unregister(struct=20
>  }
>  EXPORT_SYMBOL(backlight_device_unregister);
> =20
> -#if IS_ENABLED(CONFIG_OF)
> +#ifdef CONFIG_OF
>  static int of_parent_match(struct device *dev, void *data)
>  {
>  	return dev->parent && dev->parent->of_node =3D=3D data;
> --- a/include/linux/backlight.h~backlight-add-of_find_backlight_by_node-f=
unction-fix
> +++ a/include/linux/backlight.h
> @@ -134,7 +134,7 @@ struct generic_bl_info {
>  	void (*kick_battery)(void);
>  };
> =20
> -#if IS_ENABLED(CONFIG_OF)
> +#ifdef CONFIG_OF
>  struct backlight_device *of_find_backlight_by_node(struct device_node *n=
ode);
>  #else
>  static inline struct backlight_device *
> _

Yes, that should work.

> > +static int of_parent_match(struct device *dev, void *data)
> > +{
> > +	return dev->parent && dev->parent->of_node =3D=3D data;
> > +}
> > +
> > +struct backlight_device *of_find_backlight_by_node(struct device_node =
*node)
> > +{
> > +	struct device *dev;
> > +
> > +	dev =3D class_find_device(backlight_class, NULL, node, of_parent_matc=
h);
> > +
> > +	return dev ? to_backlight_device(dev) : NULL;
> > +}
> > +EXPORT_SYMBOL(of_find_backlight_by_node);
>=20
> It's a global, exported-to-modules function.  We should document such
> major interfaces.  Unless they are dead trivial, but I don't think this
> one is that simple.  The semantics of the return value could be
> explained, and callers should be told that of_find_backlight_by_node()
> took a ref on the returned device, and that they need to run
> put_device(retval->dev), if retval was not NULL.
>=20
> And anything else which might be useful.

Yes, I should have thought about that. I'll add some proper kerneldoc
and repost.

Thanks for reviewing,
Thierry

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQprFcAAoJEN0jrNd/PrOhejkP/3/KzP6+9e4fvJTya8qMKjnu
JWfA+69Sz4o+3Lu573gpCjNW0gCTk0+7i6HEH7rqfJI9gR9L+Clqg8zpNISv3q6/
53k1agXo1eU4RYe9Ikq3av3S5old3nahlQLuG4EsJ+kNxP+6j2ZKiiEBGpylISE7
13zGCnLIUPvikrP+I3OYfJqpK/MR8JwE+hZWOqemTwXpa1Q3S2Wy7allR3V9VBbB
FNTeiQZWPWNdTJML3H+Qi3RO/GQqhxXZfu3NqX8ViFJ2jUmtCQ5Qa9lV2HpJuBrl
qzosH0BgSeIYt2WGldbEU3Xjjzvhn4p3X2ER/qIPeGeqkKHCsjkaA0bpjkKr/QD2
zWm8j/yqNksm0X3KGHM5g3YqHiXPguO8r22NO9L1WeL8MCfOCy3pyVYNRWjJzuMK
QZiQ/T2Bl/n/MEg5dzpNcu84b7C462BY6uNUk8UmjE14STVkVgNxlR8ZVOZMhKs8
GMu9OiZEhaDjZZRYZE5a3VLxXHhSMaRpuKzw2Zp9Ul0/E9Ry3yJWujTrus63wRu2
yZpQv6SKU5dV8VkRdAGLvk+WCvTZGxUzYNt8MBQSz2nqcqj5eqNseF5C5Wb5dP/n
XrFY789zY9yCOv1ozLiBzIYmCqu8c9NkaLBCOYHKVC/GvNnGd5ImIB32zBfoXLQE
WWC5SHbIcpedC7ua5aNR
=2xc9
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
