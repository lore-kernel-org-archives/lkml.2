Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab1ELE4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 00:56:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39239 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab1ELE4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 00:56:41 -0400
Date: Thu, 12 May 2011 14:56:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless tree related)
Message-Id: <20110512145633.69302dd4.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTik+=yh3eq6Snp9SfC0xn--Deccefw@mail.gmail.com>
References: <20110512141019.72ccb7a7.sfr@canb.auug.org.au>
	<BANLkTik+=yh3eq6Snp9SfC0xn--Deccefw@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_May_2011_14_56_33_+1000_jLBs3dauDdVXxKX5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_May_2011_14_56_33_+1000_jLBs3dauDdVXxKX5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 11 May 2011 21:37:16 -0700 Javier Cardona <javier@cozybit.com> wrot=
e:
>
> Hi Stephen,
>=20
> On Wed, May 11, 2011 at 9:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > Hi John,
> >
> > After merging the final tree, today's linux-next build (i386 defconfig)
> > failed like this:
> >
> > net/mac80211/cfg.c: In function 'sta_apply_parameters':
> > net/mac80211/cfg.c:746: error: 'struct sta_info' has no member named 'p=
link_state'
>=20
> Sorry, I just saw this.  My apologies.  The fixup is valid but I'm
> trying to understand why it is needed.
> ieee80211_vif_is_mesh(&sdata->vif) compiles to 'false' when
> CONFIG_MAC80211_MESH is not defined... wouldn't the compiler remove
> that dead code? (Obviously it did not...)

The compiler will elide that code but only after compiling it, so the
code still has to be correct.

> Anyway, given that this is necessary, it's probably cleaner to extend
> the #ifdef block to the entire body of the outer if as follows:

I think you have the #ifdef one line too low.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_May_2011_14_56_33_+1000_jLBs3dauDdVXxKX5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNy2iBAAoJEDMEi1NhKgbs8hEH/jIIIY9lPk7Z77/hZ3dT6ZeV
3yL8Hv4j13b1wOxxapdyCITchm5/e37KFaR4WAgeYQ++WPOYaWG+Ai9JMSffEB38
K9qsZGrl8cSorDyu7idtXRZ1LG0MqsW1mD8JEiGEJ8GIYhFpgxOVO7A5XbDuK/m8
L3FKCejkwx8VtWm5hiMvOcE73D2DKavmjE9ucz/uMxUrNFjhoGIm53Dkm6kBJaVk
j+k8q/NiqseTzIFDu/eSA+ThdlZFM5sy29V0G1E1tJC61kcSSZ5Bb4gR3QwtcN9X
9UjQFCBiI6lBzyhXWchcdpVIxcZbSEj1gQ9sqob4l8mTWBOGxOT3B2wqY3zeSxc=
=DPpZ
-----END PGP SIGNATURE-----

--Signature=_Thu__12_May_2011_14_56_33_+1000_jLBs3dauDdVXxKX5--
