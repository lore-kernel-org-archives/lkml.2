Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2BPV01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:26:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52412 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2BPV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:26:25 -0500
Date: Fri, 17 Feb 2012 08:25:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-Id: <20120217082559.6a094265da2d5c203bfc445f@canb.auug.org.au>
In-Reply-To: <c6634d7c-b264-4a87-bab1-74408341dab0@default>
References: <20120216152316.821ac82e04a5ee30327b81c3@canb.auug.org.au>
	<20120216051552.GA5676@kroah.com>
	<c6634d7c-b264-4a87-bab1-74408341dab0@default>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_08_25_59_+1100_I=ScOEXRp9Elwo+N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_08_25_59_+1100_I=ScOEXRp9Elwo+N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Thu, 16 Feb 2012 06:39:42 -0800 (PST) Dan Magenheimer <dan.magenheimer@o=
racle.com> wrote:
>
> > From: Greg KH [mailto:greg@kroah.com]
> > Subject: Re: linux-next: build failure after merge of the staging tree
> >=20
> > On Thu, Feb 16, 2012 at 03:23:16PM +1100, Stephen Rothwell wrote:
> > > Hi Greg,
> > >
> > > After merging the staging tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >
> > > drivers/staging/ramster/zcache-main.c:2969:2: error: unknown field 'i=
nvalidate_page' specified in
> > initializer
> > > drivers/staging/ramster/zcache-main.c:2970:2: error: unknown field 'i=
nvalidate_inode' specified in
> > initializer
> > > drivers/staging/ramster/zcache-main.c:2971:2: error: unknown field 'i=
nvalidate_fs' specified in
> > initializer
> > >
> > > I do wonder if any of this was build tested with CONFIG_CLEANCACHE en=
abled ...
>=20
> Absolutely, against next-20120214, which contained commit
>=20
> 91c6cc9b5c216bd067f9af2cc64fcbe190755865
>=20
> which changed the names of those fields from "flush*" to "invalidate*".
> I am the author of that commit but it is pulled through Konrad Wilk
> (cc'ed). Perhaps Konrad's pull succeeded in next-20120214 but
> failed in next-20120215?

If a fetch fails for a particular tree on a particular day, I use the
version of that tree from the day before, so that is not the problem (and
in any case, the fetch did not fail).

> Kernel.org seems to be down so I can't see if that commit is
> in next-20120215 but if it is not that would likely cause
> the above errors.

It is in next-20120215 (and has been since next-20120124).  However, I
merge Konrad's (tmem) tree *after* I merge the staging tree, so that commit
was not present when I tried to build linux-next after merging the
staging tree.

> > > Caused by commit 19ee3ef5f4bb ("staging: ramster: local compression +=
 tmem").
> > >
> > > I have used the staging tree from next-20120215 for today.
> >=20
> > Dan, can you please fix this?
>=20
> Hmmm... moving target.  I'm trying to get in touch with Konrad
> to see if we can determine what is going on.

See above.

> The good news is that there seems to be an increasing number
> of people contributing to and building things on top of
> cleancache/frontswap stuff.  The bad news is that it is difficult
> to avoid ordering dependencies that affect -next.  My apologies
> and if you have any dependency-savvy processes that would solve
> this that we are not using, please let me/us know.

Well, if anyone had bothered to tell me, I could have reordered the
trees.  However, that does not change the fact that the staging tree is
now broken on its own.  Which means that Greg can't even do unit testing
on his tree with your code in it. :-(

One solutions is for Greg to merge Konrad's tree (or a subset of it) into
the staging tree.  Another is for this work to become a separate tree
(however, I think other stuff in the staging tree depends on this work,
right?).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Feb_2012_08_25_59_+1100_I=ScOEXRp9Elwo+N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPXRnAAoJEECxmPOUX5FEdioP/1W9Ny82dNQ7QGkphAbTmAGr
JO7CAT4PZLAYYRWazXB4+5utZgv2tcklvBsE87+xhi5bLQhC43J50AkYr6jwSBy0
2wAwSdSt0Gf71I2V+MNXlSC4PrTIua2ylMtZgBydP+IsNhWPSBncaSNKnCItnLhy
f7De6Nb6j9TkozRpiZoCghBmsx2aEQAfPWWsMPHTRGxiBbpymivdSY0WCr+wr3X5
62gMi6DACXgmqUDa6aXER8GGCbFsxzF3CGVKvde96J13RF8Vo6faH09571WE5SQ8
FwnyvSLMzLMGuRn9BhG6Dpgq8omFTgxz55yKKpT/z5cUdmce0nmgsxE782xf+rQD
LwAt63AWpTfA4Sl2V/s1CRycF2CyNs29KFG7ltTik0Wrn6gYEv4Arx3eDjVbtV0B
+RE/s/Vg89vaabFlOtgKaplBRo5CBWf008wjKtPpOcJA1uxWBAHG6cLD0tZ4Ws2X
XjreAW4Z6/r0mP6DN1oeHtXBiVy3qz4HCP0m/6OwvntcxNfZSe+f7dr+H7HOfmE1
I15wI37c0pn0NiRNzp9Mz5SXfBkrc5MfjGNxFwgvvz8JAIaFR4RAIPX/k3Rb+LIH
TCKqtujAYyLPjARLpJ5kI8mifA13IzLrK7fKdOo8AlpAE5JV8jg0RU8J1mzbnKtd
/YurmB8RWH8yKxk9tWSs
=B7yF
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_08_25_59_+1100_I=ScOEXRp9Elwo+N--
