Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2BTPpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:45:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53448 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab2BTPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:45:53 -0500
Date: Mon, 20 Feb 2012 07:45:48 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH v5 1/5] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120220154548.GB3258@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-2-git-send-email-myungjoo.ham@samsung.com>
 <20120220015400.GD3194@opensource.wolfsonmicro.com>
 <CAJ0PZbQjRt0-3+eUUdKkxrK=Jrv-_Q0i3aUx7JHJ9XsNUFLf8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <CAJ0PZbQjRt0-3+eUUdKkxrK=Jrv-_Q0i3aUx7JHJ9XsNUFLf8w@mail.gmail.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2012 at 03:17:39PM +0900, MyungJoo Ham wrote:
> On Mon, Feb 20, 2012 at 10:54 AM, Mark Brown

> >> + =A0 =A0 =A0 =A0 =A0 =A0 prop_buf =3D (char *)get_zeroed_page(GFP_KER=
NEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (prop_buf) {

> > Is the cast really needed here?

> Unless we have that cast, we get:
> drivers/extcon/extcon_class.c:89:12: warning: assignment makes pointer
> from integer without a cast

Oh, dear.  That's a very sad API but it looks like your code is OK.

> >> + =A0 =A0 =A0 =A0 =A0 =A0 extcon_class->dev_attrs =3D extcon_attrs;

> > I thought we were trying to remove classes, though I'm not sure if we're
> > actually at the point where that's happening yet? =A0Greg?

> Hmm.. I remember I was recommended to use classes some time ago (just
> a few months ago) especially for adding sysfs entries. Things have
> been changed already?

There's class like buses but they're not actually classes - I'm not sure
if the in kernel API has changed or not, though.  Like I say Greg's the
expert.

> >> +static int create_extcon_class_for_android(void)
> >> +{
> >> + =A0 =A0 if (!extcon_class_for_android) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 extcon_class_for_android =3D class_create(TH=
IS_MODULE, "switch");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(extcon_class_for_android))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(extcon_class_=
for_android);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 extcon_class_for_android->dev_attrs =3D extc=
on_attrs;
> >> + =A0 =A0 }
> >> + =A0 =A0 return 0;
> >> +}

> > Might be better to put this as a separate Kconfig option or just leave
> > it as an out of tree patch (given how trivial it is). =A0We're going to
> > end up renaming a bunch of the classes anyway I expect...

> Then, would it be proper to put "for-android" features surrounded by
> #ifdef CONFIG_ANDROID ?

That's an idea.  Though I'm pretty sure that for a simple change like
this the Android userspace could just adapt and we will be changing some
of the names of the directory entries I expect (I can't imagine we're
going to keep h2w for example) so the rename would likely be useful to
them.

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQmqfAAoJEBus8iNuMP3dPhYP/1YMueEb7i7T4RY20qSCP4wF
CDbFyv3W0QfACh0MB+nsy4dt3XkQqIhEFgI4xeC4Ft3EZe0YNtY37+q8DeV+lzaO
L4K1EEq+t1RkSZT8POrk40DFX+O/asDBHTu6Ul1SgPwltA1A8V0/GxOA3LMZ72yo
gi45gIAyerO7+FtW9IXtXBkizSoVlHlwTiuce0dOTuRCD9/p6S9go8t/9zJfHY1e
wkah8gxAZ9PNzjR4V6sIcSgk8ysCuRsURHiFFwjibnChxphk579P3v7DKmZr9eKl
eMYFvkJMVyxcN8G4epIWI7wRwnggRRH2u/OBJ3J9XII/8tRWZKDWATtrJere/MgS
js6akOrfbzYpadZZXRqORyoTrKefQkrFEJBbA5TZHjY5DFqrBLVyWKjLyQ4Lwz6V
KLzDfVZcb/oJFKZSZQXVFZBEAXO9zxVWp/R2sOZp/67QlgGBOqHLT7Md7+wVxNP6
N+j7gAnBeMbHu5f/aEUvnwrSDLUzxpqGV7V5WpoHygVBtEGf+QyvHp4M5iMxEwlE
yNAAwWpIxnkx0u+ef0L58Xnjoeg2//XmL8ASuQg+c06LaMwMp1QGHPqxN0tmS30q
mKSe22J6LcuZEkBN6hl6eWZGQJ/mLKgIf10ec2uMqaacfjmysOhRt01dGoXFoZhg
7iEj3rHc4K2Bdx7NM9vT
=Q/BD
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
