Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1LTF7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:59:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab1LTF7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:59:12 -0500
Date: Tue, 20 Dec 2011 16:58:51 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>
Subject: Re: [PATCH v2 0/3] introduce External Connector Class (extcon)
Message-ID: <20111220165851.1ee09b28@notabene.brown>
In-Reply-To: <20111220010109.GO2860@opensource.wolfsonmicro.com>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
	<20111215133229.20e7f0f2@notabene.brown>
	<20111215065154.GA24248@opensource.wolfsonmicro.com>
	<20111218181550.3fd35f6c@notabene.brown>
	<20111220010109.GO2860@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Xv=S20keqTxAPEWh76K8AgS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Xv=S20keqTxAPEWh76K8AgS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Dec 2011 01:01:09 +0000 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Sun, Dec 18, 2011 at 06:15:50PM +1100, NeilBrown wrote:
> > On Thu, 15 Dec 2011 14:51:55 +0800 Mark Brown
>=20
> > > Grant has a proposal for this which revolves around devices trying to
> > > acquire their resources and returning a "please retry" error code if
> > > they don't have all their dependencies.  Half the problem here is that
>=20
> > A possibility I have been thinking about is to multithread do_initcalls=
() and
> > have the various request functions (gpio_request, regulator_get, reques=
t_irq,
> > etc) optionally block if the resource isn't available.
>=20
> That seems to be logically the same in terms of what it actually does
> but introduces concurrency which wasn't there before which means that
> things could get reordered for random reasons.  That seems like it'd not
> be great for robustness.

Logically similar..

One important difference is that (if I understand it correctly), the "please
retry" error need to be propagated up a lot further than it currently is so
that would be quite intrusive.

While my approach does introduce concurrency which wasn't there before, any
driver that can be built as a module must allow for concurrency in the init
function so I suspect (or hope) people normally make that code thread-safe.

I have some code that almost works (will post when it does work).  The only
real issue I have found (apart from personal incompetence) is that we really
need to know up-front what resources are going to be available so we know
whether to wait or to fail (waiting until 'everything is finished' won't wo=
rk
as there could be several things still waiting at the end and we don't know=
 if
one is waiting for another, of if they are waiting for things that won't
appear).

I imagine that ultimately we can depend on a device-tree file to list every
resource (gpio, irq, regulator) that is relevant here and can write the code
to wait-or-fail accordingly.

>=20
> > Do we need to talk about devices that haven't been enumerated yet? or w=
as
> > that just if we wanted to create an explicit dependency graph?
>=20
> You need to know about devices that aren't enumerated yet.

I'm still not quite sure what you mean.  In my (limited) experience you need
to know about resources, not devices, and they have names.
And there is some precedent in regulator supply lists for naming devices
before they are enumerated.  So I'm not seeing the problem that you are
seeing.

Thanks,
NeilBrown


--Sig_/Xv=S20keqTxAPEWh76K8AgS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvAkGznsnt1WYoG5AQIE6RAAiiCoETgWeUTEGapLQsju1jXHP87HAwYn
Pd9h4WxJO4u3kZr5oYFjxvrtVtJx06p1/Vhp7QfRQf3SPtHzFJrqaVvXkJwKexH6
YDh3mXPONiJc34xFoyw7E5wn1WZJB/f02l/lexHwGKPtNxyXOXV+FczCXnExay+E
BvZyJCRcMTe3lwaUs920hnQZR+MstzvTCztsBOne/gVflJjZrRf/JlMrGaXNUlBN
ZHtVfXfw9CXpF1BCJRRKX4MdXDj/dXZLhhwznoyD7KtmQQmvSefWET+qexmEps+o
iRwh2eA4qTgZLtj7CKbfeEk0l+3Y1LREjG8zAagfF+DLrIZgZRvLI0MYXygPlsde
SPOH1h1YcHtjc21szuOZfzWvWOxc6kt7Z2xQLKedzWrPrEkcIBH2ziAgf6UjAGIE
QaJ2vI4rk5WFg6siG0Z+SCRd4Lc84kY27bdMeZ72lBBMa1OmCRWos5PwQMLKy9rx
RbevSa14TvJHxDfteP30/u/1WnPH0kNXuTSupJquKf1GHdY1/21xHOso1UdRSAFN
u3/PRciQQvSFMdMu3xhod9dPVtU5VKlbJVXzVgTz0ImYEyJgj5jx0kz78QIAeEzg
rX7/mYitRGDR0NjS+C2j1RnwRfFstbrPBFc0fxo8yv/CEwQN9ojoIXsegSmMGoEs
qDS9Yul+kH4=
=ZIUb
-----END PGP SIGNATURE-----

--Sig_/Xv=S20keqTxAPEWh76K8AgS--
