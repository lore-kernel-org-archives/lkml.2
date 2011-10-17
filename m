Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab1JQXOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:14:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab1JQXOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:14:49 -0400
Date: Tue, 18 Oct 2011 10:14:42 +1100
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative
 suspend/hibernate mode
Message-ID: <20111018101442.5bd8b8c8@notabene.brown>
In-Reply-To: <1318887801.3125.122.camel@work-vm>
References: <Pine.LNX.4.44L0.1110171417070.1749-100000@iolanthe.rowland.org>
	<1318878529.3125.80.camel@work-vm>
	<20111018081948.7f354fc6@notabene.brown>
	<1318887801.3125.122.camel@work-vm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VXyyVA2hT_URB25trDCV1ZK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VXyyVA2hT_URB25trDCV1ZK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 14:43:21 -0700 John Stultz <john.stultz@linaro.org> wro=
te:

> On Tue, 2011-10-18 at 08:19 +1100, NeilBrown wrote:
> > On Mon, 17 Oct 2011 12:08:49 -0700 John Stultz <john.stultz@linaro.org>=
 wrote:

> > > Though I also think proposed userland implementations that require
> > > communication with all wakeup consumers before suspending (which real=
ly,
> > > once you get aggressive about suspending when you can, means
> > > communicating with all wakeup consumers on every wakeup event) isn't
> > > really a good solution either.
> >=20
> > I would help me a lot if you could be more specific than "good".  Do yo=
u mean
> > "efficient" or "simple" or "secure" or ...
>=20
> Sorry. Efficient is what I mean. Having every task that consumes wakeup
> events to have to be scheduled seems like it would unnecessarily slow
> the suspend process.
>=20
> Although I also don't see how the "its ok to suspend" handshake would
> look like from the application's point of view. If the application is
> blocking in the kernel on something, I don't think it could respond. So
> this would require either signals from the PM demaon or the app to be
> sure not to block. It just seems messy. I could just be not getting
> something that makes it more elegant, so forgive me if that's the case.
>=20
>=20

Sorry - missed this bit in the previous reply.

Blocking in the kernel would be a problem.
But programs that need to respond to events tend to avoid blocking.
They usually use an event loop and non-blocking IO, or they use threads so
that some part is always ready to respond.

The same requirements would be imposed on a process that responds to wakeup
events - it just has to be able to respond to 'about to suspend' events too.

So I don't think it is any more messy then event handling always is (and if
you use libevent, most of that is hidden under the carpet anyway).


(and no:  not signals.  Never signals.  Just don't even think about signals.
I hate signals.  Use poll or equivalents - never signals (unless you cannot
avoid them))

NeilBrown


--Sig_/VXyyVA2hT_URB25trDCV1ZK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpy24jnsnt1WYoG5AQJ6uA//do5rvJnSU7KV7m8yae7yG2A2Y/v2dj7d
BQGfg64mnwpw0N50D3YUyFIK+FdTasYFAe4ewAkvpA28OIcVKRjB++jE+aXNwqx0
pyVh3Q7bi+0MJ8CidkRaMUZrNjeYynRy5QWx4gdyktk7vCAvFHM2XyL6Fl5iG/h2
h+UwJ5rEhpHOwi25/DiF74nwtxuzO7cWvwSsSBbKua3UTr91hyi6C7dXBNNU2U+A
h2o/7ZVjtJ5DwQv2EjMEjmPXO8euQMTCH3ohbEJGo303E016oWHrvlAdE316n1uZ
bYcXvuuUgv9Rk+b0C0XFtERju9vliY/Qgf7D0he4KC4uDMr1NfnSCOPeaXv+4CSg
NeAE6FLY+kqq7vUC7fxBF7lNDimFW/Fs92LVbl4cJy3jwteDUkkfMmpt117+3M78
I9wqPUPQZqIDc5qAV09GJG2D/lyCctbunO5AJZInOFzIC783pjFcu5UqLhY3CuHQ
vsY8BYAQJQPUm81z6L6OohOir3LRSZd/kRm1P7EzDJ8mG1tOkjIB4qANXviVVPVJ
GcpdIzC7CSD1MVjUYVz29CiLqeHD+PpqlKoTfkk8Fvv6hwwn9/p2jNr7l08eT8i+
o8L/vybtuQZQSAuItIIlSg/1Ti8r8sBjYvboSE3abJ87onxMDRi5xq6DfL1HX8+q
kj9oYmkpR90=
=zf3+
-----END PGP SIGNATURE-----

--Sig_/VXyyVA2hT_URB25trDCV1ZK--
