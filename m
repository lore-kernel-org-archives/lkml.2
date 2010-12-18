Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0LRAwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:52:53 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:32808 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab0LRAwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:52:49 -0500
X-Spam-ASN: 
Date: Sat, 18 Dec 2010 03:52:39 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 16/16] pps: add parallel port PPS signal generator
Message-ID: <20101218035239.11d59828@apollo.gnet>
In-Reply-To: <20101217161837.5f083e73.akpm@linux-foundation.org>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<c297ae1ac0479685b45191c950317a0cc3406822.1292604060.git.lasaine@lvk.cs.msu.su>
	<20101217161837.5f083e73.akpm@linux-foundation.org>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/Z5+BbRBqum/zTwhIUQboU7w"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Z5+BbRBqum/zTwhIUQboU7w
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 17 Dec 2010 16:18:37 -0800
Andrew Morton <akpm@linux-foundation.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Fri, 17 Dec 2010 22:54:40 +0300
> Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
>=20
> > +static enum hrtimer_restart hrtimer_event(struct hrtimer *timer)
> > +{
> > +	struct timespec expire_time, ts1, ts2, ts3, dts;
> > +	struct pps_generator_pp *dev;
> > +	struct parport *port;
> > +	long lim, delta;
> > +	unsigned long flags;
> > +
> > +	/* NB: approx time with blocked interrupts =3D
> > +	   send_delay + 3 * SAFETY_INTERVAL */
> > +	local_irq_save(flags);
>=20
> ditto.

The same thing here: we don't want random lags due to other local
interrupt handlers.

--=20
  Alexander

--Sig_/Z5+BbRBqum/zTwhIUQboU7w
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNDAXXAAoJEElrwznyooJbN5oH/2rYzKi3+W0oH6y3KNBSm8kU
LlgplvXKFzEjoVzgHhvR0kxdo6Y26ab+iTMOmdkYsgqsDFbY+7xr6DpAUWBQqbvJ
AoC6D36OjR4TFm3TztS8Ejcnqi1fqVAMOXlmUzglC+YBNKpaEeS4r0emgGiCpCZz
Nhs9M470IG8WTJuom3THEhDCLPMD6UasCClod9ommq6yC3dEaWDj86k9UjRggD/6
5mHEcej6weWDLVwwVRIRkPelACMW39lxhD/2pAsc9WcQcccCcf6+COgqsZtFk+6o
k4kloMMlg0fqKpqdAbU0mnMK61l5Swm4Fjp8e7FlRx/NHMdtqzHBIdpJvzPssZw=
=wjKp
-----END PGP SIGNATURE-----

--Sig_/Z5+BbRBqum/zTwhIUQboU7w--
