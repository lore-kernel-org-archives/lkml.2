Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab1LRHQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 02:16:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1LRHQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 02:16:12 -0500
Date: Sun, 18 Dec 2011 18:15:50 +1100
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
Message-ID: <20111218181550.3fd35f6c@notabene.brown>
In-Reply-To: <20111215065154.GA24248@opensource.wolfsonmicro.com>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
	<20111215133229.20e7f0f2@notabene.brown>
	<20111215065154.GA24248@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R9sKTVA6jqWbY1riPC0VmUV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/R9sKTVA6jqWbY1riPC0VmUV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 14:51:55 +0800 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Thu, Dec 15, 2011 at 01:32:29PM +1100, NeilBrown wrote:
>=20
> j> 3/ The use of extcon_get_extcon_dev() requires that the port device be
> >    registered before the device that wants to be notified by it.  Ensur=
ing
> >    correct ordering of device discovery is (I believe) not always easy -
> >    particularly with module loading.
>=20
> This is a massive problem throughout the kernel=20

So it seems.  I just tripped over it with regulators. When one is supplied =
by
another they need to be probed in the right order.
Sounds like we need to find a general solution.

>=20
> >    Would it make sense to instead have one device register as a
> >    switch-provider and the other device register as a switch-listener a=
nd as
> >    soon as they both exist they get connected: a bit like how 'devices'=
 and
> >    'drivers' can be registered in any order.
> >    Maybe the same device/driver infrastructure could be reused (an extc=
on
> >    bus maybe?) but I'm not really familiar enough with it to say (Greg?=
?).
>=20
> Grant has a proposal for this which revolves around devices trying to
> acquire their resources and returning a "please retry" error code if
> they don't have all their dependencies.  Half the problem here is that
> coming up with the dependency graph (and finding ways to talk about
> devices that haven't been enumerated yet) is a very hard problem.

I can see how an -EAGAIN might work ... and it would exercise a lot of error
paths that otherwise never get called - I wonder if that is a good thing :-)

It doesn't feel quite like the right solution though.  Deciding when to ret=
ry,
and where to queue the device/driver pairs might be messy.

A possibility I have been thinking about is to multithread do_initcalls() a=
nd
have the various request functions (gpio_request, regulator_get, request_ir=
q,
etc) optionally block if the resource isn't available.

We wouldn't create a new thread for every initcall, just when all current
threads are blocked.  And threads that have to block die once they finish
their initcall, so there is only ever one that is allowed to move on to the
'next' initcall.

Do we need to talk about devices that haven't been enumerated yet? or was
that just if we wanted to create an explicit dependency graph?

We would need names for resources that haven't been registered yet but that
seems fairly with with simple string names assigned in the board file (or
eventually the device-tree file I guess).

I might try hacking something together and see how badly it breaks.


>=20
> >    Are there other examples of inter-device dependencies that can be us=
ed as
> >    a model?
>=20
> The current solution is to fiddle with initcall order so that drivers
> for devices that other devices depend on enumerate first.

:-(  I was afraid of that.

NeilBrown


--Sig_/R9sKTVA6jqWbY1riPC0VmUV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTu2TJjnsnt1WYoG5AQKiTQ/+LRhDSQDh2aScbutXCygXfohwSU+SvJwJ
qs2x253mSHZyjJCWM2gO3bMwNCjmcxD5fB8O8YUFuj3KGXFcF9RChjr44Tvf0qTG
bYZu/o1DPWNH3r/4jcMcGuaj9RBQLBVNu5mP5STLHY/k+WjXyLMiNcoemJwKmL71
txayw7kDzmuToLS2UnLmepcW2Y/eFNW3Yz71NIi5rZKbV8SDqUlFxS2vwYRcUq+t
+DtvP0I8ndkIe0XhysCNAU/SfGk1gyNDGE6k2o9MAjcSmSwJ/vqGzS38G7Ibzl91
twWVR0wfLvWkFfg85mC3MV5WmWTTosAAmrWHncsFVYnJKR9Q58vs9gVHZT5aLFvD
HdH4pqU+6eJnjiZlcm3blFOCbkS41zPgiWgsN9MyVssIw4KdFbGcOSfPMUzjzl24
qGwWOPog62icXGA7hEH6bqxOuHHayDzB8Pcf9fB6+DhmEZC5mGMnCzx23MafBJYD
Uz+b1OHdum3RJjPVMbJRVhSjW9C2MpBFvnU+j03NcJKWRtRcct6+mWXK9GnQ2Hqe
j9JLC6DPLKu9lwuFSrOI65j0GUkj8rUqux2zqezldYWHnrH844F8R4OM/l8XkSAH
ZeUm6LJh0rlretWc/33z4kwlHIy67LrsGdzyyCsgg4hSUAzwljQbWzW/n4skQDaG
EcBM9GLhcnA=
=x6Td
-----END PGP SIGNATURE-----

--Sig_/R9sKTVA6jqWbY1riPC0VmUV--
