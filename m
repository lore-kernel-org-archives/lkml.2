Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2HTF62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:58:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab2HTF6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:58:25 -0400
Date: Mon, 20 Aug 2012 07:58:17 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Kim, Milo" <Milo.Kim@ti.com>, Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds-lm3530: replace pwm platform functions with generic
 pwm functions
Message-ID: <20120820055817.GA17149@avionic-0098.adnet.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
 <201208200537.48993.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <201208200537.48993.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:x+kMgqGx2umlitCEE+JNtHXU5mNMWwjn9VvrBfNH8WF
 df4qFnKfJ9JLxUmKLKIAb9RxI2wcZ6p9MN9zG4B06IAc0QFoos
 w9NjuMNDQ7EYNcVznxznyak56+6pq4sAS7x8UK00v20rqRFf7I
 rbxF1UPihHy1lpL+7V3kQHUMjb/w8qpWoIgpR6X20WgovF5MxW
 //723QFd/Uz2TkUOgxoZe3UyPqeU7992dWOaJjWYApLljg/eOb
 5txe1OfULqE2mm9BWCOd26AN3JGiKMSXL04D0A9311W2KRJWQQ
 xxurFBU79Y/qKaInFpFFKH8yyrq9mkQo6dXlI9ES59O+36NXiH
 t9IO9prlOZYCeXtXJGwTwZ+00SNOaflVFuHjDrx56iAYUUcDS8
 VGxpptat6nLLhx5wwbtrxPQld51x1Xagw8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 05:37:48AM +0000, Arnd Bergmann wrote:
> On Monday 20 August 2012, Kim, Milo wrote:
> > +#ifdef CONFIG_PWM
> > +static int lm3530_pwm_request(struct lm3530_data *drvdata)
> > +{
> > +       int pwm_id;
> > +
> > +       /* if the pwm device exists, skip requesting the device */
> > +       if (drvdata->pwm)
> > +               return 0;
> > +
> > +       pwm_id =3D drvdata->pdata ? drvdata->pdata->pwm_id : 0;
> > +
> > +       drvdata->pwm =3D pwm_request(pwm_id, "lm3530-pwm");
> > +       drvdata->period_ns =3D drvdata->pdata ? drvdata->pdata->period_=
ns : 0;
> > +
> > +       return IS_ERR(drvdata->pwm) ? PTR_ERR(drvdata->pwm) : 0;
> > +}
> > +
>=20
> A few comments on this:
>=20
> * Rather than having to do the #ifdef here, I think it would be better if
>   the PWM subsystem provided stub functions for pwm_request, pwm_config,
>   pwm_enable, pwm_disable and pwm_free that do nothing, so you can in eff=
ect
>   let the compiler optimize away the above code.

That's actually on my TODO list, but I think it needs to wait until we
have gotten rid of all legacy implementations. The stubs would have to
move into the !CONFIG_PWM branch, which will in turn break because the
legacy implementations would provide non-inlined duplicates.

Thierry

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQMdH5AAoJEN0jrNd/PrOh9ZUP/AoLfwzIAmtYmAPr2lZsS3lF
wMlRZngBizYG4Bsfeqef8KuL+8b/HMzxVyYJX1/9kr7+rfjlPxGVJOUVKLG289Fr
KhJsUqfEpxh4VS9kGyRsGiYW+6/2bZkXli2GHIdYNhdAgup8P3iX6IfaWyWs8gLF
NKmByx4IkKAqMnNEbGnK3m51dtKs5aDeoxiI1+OM4yawcD4sPVwmNzGVmF5qv2+Z
wgKukwe/+feVTJgHoKylXWom7p2UZlJfyODq+9gPCALA/XU3EF/Vh08j1f4QJHxm
MZiRJ3d4ax46ulxr1aeyujfibD8XGu6aL4KEQxxtaiDlfMPtEXg+h+dF6oSg5LoM
/37QIrswpJ2DQUNpMEsfrcpDdrqkL0UwUVQQk5NxeIBtTgCywZZM7Wq7fN//TAaX
MC2fj1ukRao9LEvibL0a8LJezcl1a0j88r3S8APrXHDxioHsKzNTL4KJst9JC83p
Tf1CzfUaKh8bgQxMPeVDH+85WJoiSFZWUGmJqRma/9waYKiDdB/YslhkpPRVmn1D
rby0W/ZDWLJQracEbWcL06WR8qSx6wrdvXSg4yXfeCWcORVMoDhr4mmFDV48iZld
Zg1bCACSJPcVU+fnorGhZr0auPQxc00qhP0DoxA/PBS17emh7RyTDJdb7uYrigIH
i2rFlqlAAl0Mu1qnp07r
=7UcR
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
