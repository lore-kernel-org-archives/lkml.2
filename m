Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2DYF0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:26:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab2DYF0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:26:10 -0400
Date: Wed, 25 Apr 2012 15:26:03 +1000
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: twl4030 power button: don't lose presses on
 resume
Message-ID: <20120425152603.3d24547f@notabene.brown>
In-Reply-To: <20120425050919.GB27843@core.coreip.homeip.net>
References: <20120425122139.512c6890@notabene.brown>
	<20120425050919.GB27843@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/klFw2H1hDUnKfS+VV9SEI+9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/klFw2H1hDUnKfS+VV9SEI+9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Apr 2012 22:09:19 -0700 Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> Hi Neil,
>=20
> On Wed, Apr 25, 2012 at 12:21:39PM +1000, NeilBrown wrote:
> >=20
> > If we press and release the power button before the press interrupt is
> > handled - as can happen on resume - we lose the press event so the
> > release event is ignored and we don't know what happened to cause the
> > wakeup.
>=20
> What kind of latency do you observe?

When I have debugging enabled, hundreds of milliseconds.

When I don't have debugging enabled ... it doesn't tell me, but I'm fairly
sure it is several tens of milliseconds and the button press can be quicker
than that.

If it will help I can try to instrument the driver and get some timings.

>=20
> >=20
> > So make sure that each interrupt handled does generate an event.
> > Because twl4030 queues interrupt events we will see two interrupts
> > for a press-release even if we handle the first one later.  This means
> > that such a sequence will be reported as two button presses.  This
> > is unfortunate but is better than no button presses.
> > Possibly we could set the PENDDIS_MASK to disable queuing of
> > interrupts, but that might adversely affect other interrupt sources.
> >
>=20
> It looks like we'd have to modify every driver to ensure consistent
> behavior as we do not have any guarantees on how long resume takes.
> Maybe this is something that input core needs to implement?

Well if every driver is buggy....

I don't see how this could be implemented in the input core.  And even if it
was, you'd probably need to change each driver to interact with this new
functionality which would be much the same work as changing them to work wi=
th
the current functionality....
But maybe I have no imagination - if you can suggest a way that the input c=
ore
could support this without changing the drivers, I'm happy to try it out.

Thanks,
NeilBrown

--Sig_/klFw2H1hDUnKfS+VV9SEI+9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5eK6znsnt1WYoG5AQLyWw//Uajlw6vtJCkOI22ElIrr9Rzpl+O9wVMf
dqTc0VCiRxEyBFUXudziN4GtNs9XdLfBRvWr8NhrSqVJHX+8nsWmzrIUD/wXc8kM
UmL0EhcRa3hw2J3lU4bOxhgsYh+6iR83OdCc9Jn5jHyGOXULnjc75MmVzXYVNIUd
b2b3k/CQ4IkqoXvLHG58h7/vwIdRe/qaAKF7hlGBAVmYXk0+x/po+ep9i2UdnC/G
YtUPVSO4Cvl/8l8XEYksrBTneW8CUNEb58e7ff49R5/Eleiv480WDKi8mhUBxu6A
5WvdtDcDNrtW6RTXmwZUzmFfkOfbh4I9gkDG2zO7R2LKFxzIcLhw0hF35eiuqyKP
crqrq1DUnlLPpd3b/sJShDuQQs6FnBB5pJYznj/d51Qft/iijq8idO6mOmyRBp9p
U83kS8DI5kou9+zXTbs1YrsQDEb3GqVCmt9NUxKtl93GEGgIiTv5TITieo0xc2rs
KSoqSE0zN738OWcFwhodd6KOIXqI/0lqBuqkYs41ggecYFSwB+obC5s95dbp5j0v
AovuZmWZsPQt/NWaBWgskMNdzAyoSvkLGAox+K34vrb70hZPTzcMLFMYa7yyUA05
tnLHsG7LZIuLU6kG6b20CTmhpe3rueOKxjeScVulWJeS0BEMzxrxc5BVJuNZzZZ8
0hGdr+Jysw0=
=dE7s
-----END PGP SIGNATURE-----

--Sig_/klFw2H1hDUnKfS+VV9SEI+9--
