Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab2IXXhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:37:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab2IXXhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:37:52 -0400
Date: Tue, 25 Sep 2012 09:37:43 +1000
From: NeilBrown <neilb@suse.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: makes bio_split support bio without data
Message-ID: <20120925093743.757f0a95@notabene.brown>
In-Reply-To: <87txunyg15.fsf@sejong.aot.lge.com>
References: <20120924145639.3b65fd8b@notabene.brown>
	<87txunyg15.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t2PTMmK7wxzSKIISuKGFVE0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/t2PTMmK7wxzSKIISuKGFVE0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Sep 2012 17:35:34 +0900 Namhyung Kim <namhyung@kernel.org> wrote:

> Hi,
>=20
> On Mon, 24 Sep 2012 14:56:39 +1000, NeilBrown wrote:
> > Hi Jens,
> >  this patch has been sitting in my -next tree for a little while and I =
was
> >  hoping for it to go in for the next merge window.
> >  It simply allows bio_split() to be used on bios without a payload, suc=
h as
> >  'discard'.
> >  Are you happy with it going in though my 'md' tree, or would you rathe=
r take
> >  it though your 'block' tree?
> >
> > Thanks,
> > NeilBrown
> >
> >
> > From: Shaohua Li <shli@fusionio.com>
> > Date: Thu, 20 Sep 2012 09:36:03 +1000
> > Subject: [PATCH] block: makes bio_split support bio without data
> >
> > discard bio hasn't data attached. We hit a BUG_ON with such bio. This m=
akes
> > bio_split works for such bio.
> >
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > diff --git a/fs/bio.c b/fs/bio.c
> > index 71072ab..dbb7a6c 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -1501,7 +1501,7 @@ struct bio_pair *bio_split(struct bio *bi, int fi=
rst_sectors)
> >  	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
> >  				bi->bi_sector + first_sectors);
> > =20
> > -	BUG_ON(bi->bi_vcnt !=3D 1);
> > +	BUG_ON(bi->bi_vcnt !=3D 1 && bi->bi_vcnt !=3D 0);
>=20
> Why not
> 	BUG_ON(bi->bi_vcnt > 1);
> ?

Either is fine with me.
'1' and '0' are the cases that bio_split explicitly supports.
'>1' are the cases which will cause problems.

As bi_vnt is unsigned, both conditions should produce exactly the same
machine code.

As I see no reason to prefer one over the other, I'm happy to go with what =
the
original author wrote.

Thanks,
NeilBrown

--Sig_/t2PTMmK7wxzSKIISuKGFVE0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGDuxznsnt1WYoG5AQLrbA/+NoOwxfTRXpsJgOi3oe859XLNSJ/3V9sG
69StsAAMszxKWN2iqamd59m7a9gScZDABWVw45HPak6sRNiMf1oRgufszkqTZmrV
wEfu2zlYwV/9x2G2Hu2tOwzVfw6399VFlfoYAKJWQfmlf3DaBsYsCss2rmUKJl29
SHgzaSZJa7s+O4vOtX6GFCnmMI1Do3U8CdCeDahi2WdymCAcsDk1fWv7PihrdhC/
kMQ0Tpoqsyye3YvSp8XLlG0gvJrmE7AI2coZm8RXfNsBw89Hw/4K+iFi/g7QIYgf
l/E2dUZtlGZAgCbza/nBuO+LgvUh0tu47MVyI199rHiw07vcr0rdd0PouBQhT5yM
aEMXCHuReev955DpbYYKciJR3+8enCO6F9Z6zEAH4BLoHemjRfnZjxK9+jmsGj2b
+ykPhGzeCSjnoD+6huTBt/lJGbeAC/pemFOfhnWdR7XHDKQlxTkWs+eTXOWNMKfm
kE6negAhVxUWEhIJ2jYzK4M/hDky/kXg09eW8GMuPwSw6Y2TLo3KUafK6h2kAm3Q
tpUQUYqL64k4YAXeE0apUjk+3ttzoPsdwY0baosSMOsK05U4AbwCvZ660V7RHom4
7vDYVzhsumFLi7YAeLuODueAfEL+RyumCt2M4bVX4MorDiDjMzqFr+D4pmT+vJvQ
U1buLp6a8nA=
=Mq98
-----END PGP SIGNATURE-----

--Sig_/t2PTMmK7wxzSKIISuKGFVE0--
