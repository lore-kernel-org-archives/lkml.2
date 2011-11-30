Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1K3XFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:05:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab1K3XFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:05:13 -0500
Date: Thu, 1 Dec 2011 10:04:57 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg KH <gregkh@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        Arve =?ISO-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111201100457.0d3f6b19@notabene.brown>
In-Reply-To: <CACRpkdY0vhV6cQgYDhfqAfGWVWWEsiFW4vJ7uumvWwigobpwUw@mail.gmail.com>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<20111127230836.GA29728@suse.de>
	<20111128123114.2601bd7c@notabene.brown>
	<20111128072713.GA17724@suse.de>
	<20111128090446.GB18919@core.coreip.homeip.net>
	<20111130063500.GB12052@suse.de>
	<CACRpkdY0vhV6cQgYDhfqAfGWVWWEsiFW4vJ7uumvWwigobpwUw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QhW2LAGYAAzp11YZplI8EP_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QhW2LAGYAAzp11YZplI8EP_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Nov 2011 14:28:36 +0100 Linus Walleij <linus.walleij@linaro.org>
wrote:

> On Wed, Nov 30, 2011 at 7:35 AM, Greg KH <gregkh@suse.de> wrote:
>=20
> > So, how do you want this type of interface to look like, uevents only?
> >
> > Or something like gpio?
> >
> > Actually, why can't we just use gpio as-is here and just treat these
> > devices as "generic" i/o "pins"?
>=20
> For device drivers we have the issue that the management of
> the GPIO pin-space give me the creeps. It is simple when things
> are simple and then ugly things have start to happen, such
> as dynamically bumping the GPIO pin range and associated
> IRQ range at compile time using unreadable nested macros.
> You roof the space at some arbitrary number at compile-time
> in ARCH_NR_GPIOS and if you don't define it,
> <asm-generic/gpio.h> will helpfully define that your system
> has 256 GPIO pins.
>=20
> The effect of the above on unified cross-ARM-arch kernels is
> confusing as the meaning of the GPIO pinspace will
> shift at runtime depending on what system it's running on.
>=20
> A new subsystem could allocate switch/pin/line assignments
> dynamically which is way more viable. (And how we chose to
> do in in pinctrl.)
>=20
> For userspace several people, notably the GPIOlib subsystem
> maintainer Grant, expressed concerns about the sysfs interface
> to GPIO. So I would not shoehorn new stuff in there, solidifying
> it even more.
>=20
> So I would recommend doing this as a new subsystem to save
> us from trouble. There is more to be gained from splitting things
> apart than keeping them together in this case IMO.

I certainly agree that if the GPIO interface causes problem we should be ve=
ry
careful about extending the use of it.
However I think it would be wrong to simply make something that is different
just for the sake of being different. I will probably introduce a different
set of problems of its own.

Do you know what it is about the sysfs-gpio interface that is problematic?
If it is just one aspect, maybe that can be avoided and the rest still used.

For example, I note that most GPIO pins that are exported via sysfs are
exported by number.  This is problematic exactly as you have described
above.  Numbers change.
However it is quite possible to export GPIO pins by assigning a name.  Doing
this would remove the problem.  We don't need to assign a name to every gpio
pin, just the ones that we want to export to user-space.

If this was the only issue, we could require that when exporting 'switches'
through sysfs it was only done if a name was supplied.

So: do you know what specific concerns have been expressed concerning gpio
and userspace?  I think it best to address specific concern rather than thr=
ow
it all out and start again.

Thanks,
NeilBrown

--Sig_/QhW2LAGYAAzp11YZplI8EP_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTta2mTnsnt1WYoG5AQLJsQ/9GTPFe7/B12SFi2N+d/yj9EjDoHsRCw2Q
fF3LUfgNZrJNdXQYxxD++OYRtme46Zkwc1h9CXG3vkXvuf71+h7bR2Ocr0/AJLSF
FXuDq6sXpyypkqRk/yaNEa4zxR5bxgLdYMf7ccCsdB2ZGyGMt8RjG1/zzcMf+SQi
eeb5XxtfbJFkgNUQKdVX0ahrTcrRf/iQ7qUxZkmJgYe4uiv3OAIbOgxkk6WcZgFg
158S+0QUtJ2R73Jpe8QZYKVB1rYiqo2Zlm2bA0PrTjOS2EHHem1wXosfqSoa6uGF
X8By4ZlGaML/9DjSPLwtkWo1l7IexgjYXSNQSRtbrNJL7HpXirDZyVkBVkoFu3d2
JxFaMbCV8RYeCWoTqpjd+DxJD/VO5taKnajkCNIdvEv8XoNXObL1oVKyUcRX5r6g
VqV1mKdci9PXV5/jgAvNNYc+rgLouwyuFYgAfT0iKmK8lAJXcGtwg4i++HNbHWPg
rfpxMGoBUG9GAZFhG0zk0walu2QJ8BmU/qfkXX5w7AstpYFkNCjRkNACO1DiVe2C
8tuyy+26SjHQLDJkMV59aQIy7L/q/z79Q4PCugPLLrsXKeJKGXsrm3LolZCJ3yRc
nO2KdFzGqne++j8/AJ5PVTGy+3ebHt8luW+thwSLJnyDJXDKj473T9nY9C2/86Ew
VzhU9VW7NkM=
=QXuz
-----END PGP SIGNATURE-----

--Sig_/QhW2LAGYAAzp11YZplI8EP_--
