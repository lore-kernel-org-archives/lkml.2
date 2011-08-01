Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1HAAft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:35:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45970 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab1HAAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:35:44 -0400
Date: Mon, 1 Aug 2011 10:35:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, <linux-raid@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the moduleh tree
Message-Id: <20110801103537.a273ddac48fc81a8f28c2f90@canb.auug.org.au>
In-Reply-To: <20110731082405.GM31842@windriver.com>
References: <20110729152548.17e093cb01d95077a05d4cec@canb.auug.org.au>
	<20110731082405.GM31842@windriver.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Aug_2011_10_35_37_+1000_JBJtInSUvgF70A6m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Aug_2011_10_35_37_+1000_JBJtInSUvgF70A6m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 31 Jul 2011 04:24:05 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> [linux-next: build warnings after merge of the moduleh tree] On 29/07/201=
1 (Fri 15:25) Stephen Rothwell wrote:
>=20
> > Hi Paul,
> >=20
> > After merging the moduleh tree, today's linux-next build (x86_64
> > allmodconfig) produced these warnings:
> >=20
> > drivers/md/persistent-data/dm-block-manager.c:103:1: warning: type defa=
ults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> [...]
> > drivers/md/persistent-data/dm-space-map-disk.c:634:1: warning: type def=
aults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> [...]
> > drivers/md/persistent-data/dm-btree.c:146:1: warning: type defaults to =
'int' in declaration of 'EXPORT_SYMBOL_GPL'
> [...]
> > drivers/md/persistent-data/dm-btree-remove.c:569:1: warning: type defau=
lts to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> >=20
> > I have added the following patch for today:
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Fri, 29 Jul 2011 15:16:04 +1000
> > Subject: [PATCH] include export.h to use EXPORT_SYMBOL
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/md/persistent-data/dm-block-manager.c  |    1 +
> >  drivers/md/persistent-data/dm-btree-remove.c   |    2 ++
> >  drivers/md/persistent-data/dm-btree.c          |    1 +
> >  drivers/md/persistent-data/dm-space-map-disk.c |    1 +
> >  4 files changed, 5 insertions(+), 0 deletions(-)
>=20
> This one is a bit more interesting.  The above files (and actually their
> parent dir) doesn't exist yet in master/HEAD.  So I can't patch them
> yet.  And the MD maintainers can't patch in export.h usage, since they
> won't have such a header file.
>=20
> If you didn't want to temporarily carry it, I can think of two things:
> I suppose, since the one single commit that creates export.h is totally
> standalone, and harmless/inert in itself, we could perhaps get it pulled
> independently if it made life easier for others to align to the right
> usage?  Or they can just patch in module.h usage and we can downgrade
> them to export.h usage shortly thereafter.

I will carry it for now (as a merge fixup on the moduleh tree.  If the
export.h split goes to Linus, then Neil can apply it to his tree, or
Linus can apply it as a merge fixup ehen he merges the latter of the two
trees (as long as someone remember to tell him).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Aug_2011_10_35_37_+1000_JBJtInSUvgF70A6m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJONfTZAAoJEDMEi1NhKgbsWrkIAIUOb1KB4E8OERWU6sQyKqed
5sRUXyDSq5/c5kkyMy5KTXHJ+vUURnZJjQqzuCYm6svP4ecnRWa2Xx3NyPFvQcd3
fYwv9sL1A0kLUtK7MBMmsMMqHOHe7inEI0AhSjMm4BXFGWfDgWwGFF/uTGFfZjLb
pVSZFBR9GS5ttuQD4ac+ns8byP6AWJAGWYD/srUCF7+Z+vESkhi8JqDQv6HBK1ZQ
tKw8AUGKBkeEQIl8J3KgayfO8rhapEUqhYZbAtBjH8zd0Re2hK6VdUPWBumeA8P3
ZE9invdNm3deCSda6AIxkIq0r0Cd2PKbFHLfELqfm0U3e8WzghYsUZoFBUIIc9w=
=f/IF
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Aug_2011_10_35_37_+1000_JBJtInSUvgF70A6m--
