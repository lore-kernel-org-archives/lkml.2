Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0DUAVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:21:42 -0400
Received: from ozlabs.org ([203.10.76.45]:48820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0DUAVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:21:41 -0400
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, schwab@linux-m68k.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
In-Reply-To: <20100421155547.GA4222@x200>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vUB.fSSzLB@tosh>
	 <alpine.DEB.2.01.1004192339190.13016@bogon.housecafe.de>
	 <1271765898.4324.2.camel@concordia>  <20100421155547.GA4222@x200>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ks/erLzbOJ+lZLQiQRTx"
Date: Wed, 21 Apr 2010 10:21:39 +1000
Message-ID: <1271809299.13262.6.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ks/erLzbOJ+lZLQiQRTx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-04-21 at 18:55 +0300, Alexey Dobriyan wrote:
> On Tue, Apr 20, 2010 at 10:18:18PM +1000, Michael Ellerman wrote:
> > On Mon, 2010-04-19 at 23:45 -0700, Christian Kujau wrote:
> > --- a/fs/proc/proc_devtree.c
> > +++ b/fs/proc/proc_devtree.c
> > @@ -175,6 +175,24 @@ retry:
> >         return fixed_name;
> >  }
> > =20
> > +static const char *unslash_name(const char *name)
> > +{
> > +       char *p, *fixed_name;
> > +
> > +       fixed_name =3D kstrdup(name);
> > +       if (!fixed_name) {
> > +               printk(KERN_ERR "device-tree: Out of memory trying to u=
nslash "
> > +                               "name \"%s\"\n", name);
> > +               return name;
> > +       }
> > +
> > +       p =3D fixed_name;
> > +       while ((p =3D strstr(p, "/")))
> > +               *p++ =3D '_';
>=20
> This is wasteful. :-)

Whatever, patches welcome :)

> Also, I hope we won't spit message every time allocation fail.

We do. Your system is mostly hosed anyway, but feel free to rate limit
it or something.

The error handling in there is a bit dubious, if the alloc fails we just
return the old name, which we know is bogus. It should probably return
NULL and the calling code can check - same for fixup_name().

cheers

--=-ks/erLzbOJ+lZLQiQRTx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkvORRAACgkQdSjSd0sB4dKJqwCgq79/5W+simjGRQJ4tQYpfcX7
gzoAoLD3mnRvEEi8RnPB+OidBrer+tPx
=9O+3
-----END PGP SIGNATURE-----

--=-ks/erLzbOJ+lZLQiQRTx--

