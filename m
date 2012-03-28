Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab2C1VLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:11:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2C1VLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:11:21 -0400
Date: Thu, 29 Mar 2012 08:11:09 +1100
From: NeilBrown <neilb@suse.de>
To: shuahkhan@gmail.com
Cc: rpurdie@rpsys.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120329081109.5e8bbd59@notabene.brown>
In-Reply-To: <1332950949.2305.10.camel@lorien2>
References: <1332861697.2834.9.camel@lorien2>
	<20120328104544.593f3d1a@notabene.brown>
	<1332950949.2305.10.camel@lorien2>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=5xnBLmsmkYW4RRoyOKZqg."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=5xnBLmsmkYW4RRoyOKZqg.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 10:09:09 -0600 Shuah Khan <shuahkhan@gmail.com> wrote:

> Neil,
>=20
> >=20
> > In general I approve of this - thanks for your efforts.
> >=20
> > However there are some details that need attention.
>=20
> Thanks.
> >=20
> > >=20
> > > This patch implements the one-shot-timer trigger support by enhancing=
 the
> > > current led-class and ledtrig-timer drivers to support the following
> > > use-cases:
> > >=20
> > > use-case 1:
> > > echo one-shot-timer > /sys/class/leds/SOMELED/trigger
> >=20
> > I don't like the name "one-shot-timer".  This name describes how you ex=
pect
> > the functionality to be used, but not what the actual difference between
> > "timer" and "one-shot-timer" is.
> > That difference is simply that one-shot-timer does not start an initial
> > default blink, while "timer" does.
> > So a name like "timer-no-default" would be a more accurate description =
and so
> > should be preferred.
>=20
> Yes, timer-no-default describes the enhancement I am making, better than
> one-shot-timer does. I will generate patch v2 to address your concerns
> and will change the name to timer-no-default and update the relevant
> code and documentation that goes with the patch to reflect the change.

Thanks.


>=20
> >=20
> > kstrtoul is currently preferred.  It ensures uniform error codes.
> >=20
>=20
> Yes. I noticed the checkpatch.pl warnings. This change is better made as
> a separate patch. Do you mind if I deferred it and volunteer to fix it
> in a separate patch shortly. :)

A separate patch is certainly a good idea.
I would do the clean-up patches first, and then have the big change at the
end of the series.  That way checkpatch won't complain about anything in yo=
ur
change.
But you should do what you are most comfortable with.

>=20
> >=20
> > > +=09
> >=20
> > Do you need to led_trigger_unregister(&timer_led_trigger) if the regist=
ration
> > of one_shot_timer_led_trigger fails?
>=20
> Yes, considered that while I was changing this routine, and thought
> might be better to leave the registered timer alone when the second
> registration fails. I can go either way.

The important point is that if timer_trig_init fails, then timer_trig_exit
will never be called.
So when timer_trig_init fails, it must ensure that it has un-done any bits
that it successfully did.

NeilBrown

--Sig_/=5xnBLmsmkYW4RRoyOKZqg.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3N+bTnsnt1WYoG5AQKePw//dIUmF7Jrg7UIpDMLBT+W78sApTP6BIW+
ylv7ETowqTCr34iOQUVNakunG9qEiPbIOkxgn/WTjI7xgut+hFfee+Ym5ppj3LEs
j41o6Mxc4zF4XUgQKqVvf2mNuseWDosjgu10aBXnZgy1iCJkQvsyjqyDaEpPEiv2
blxWLZ/wgPbj7vFBhMsDjvqWR0WKPRtKij0WOYo2tMXlY/NrLbB3AfIBDxqUwvUM
+OCY1xQKBmOBEmBTxTICxDIz9bHq2K8r8/6jIMChsYBLTPLu3zSRLmGIyUVyCIKF
jgozq108kz8WgAUwOYUHfl6fN6W8VJPQ5QMw8SbItqwm1/OnP6Wv083TP44Mv1zh
DMh9gikha5U8vtfqef3pgKdP2vi/HHlG2JNh+DTt++p9PmCAhWbuBXb4ze46DuLX
3LeP67oAbYWh+C1V/T7p4QeBi8RN96+0F7ahe2hriIuUnUesJM+QBkMN3/Hw1aUn
1i4QPjD51VU4wM6KlOB0qHc2QynLaFP37fp+W1idtessd2N0LrutLjkrHYGtBq1Y
KnbEDgZG8S1E0n6T9x3sRZYIxCA5ZRnD/D4QHWw9R6nyk7jXXC3B+qQiHj3lhCiU
H7uMz1IxWkX40XhRXjHepvteWtef53pr990KzrcJ20sxHUDc5nLe+VnjbbhCP4xv
MfK4b9Obj3I=
=OnSS
-----END PGP SIGNATURE-----

--Sig_/=5xnBLmsmkYW4RRoyOKZqg.--
