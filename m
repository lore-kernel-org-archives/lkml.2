Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab2BSHGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 02:06:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab2BSHGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 02:06:32 -0500
Date: Sun, 19 Feb 2012 18:06:08 +1100
From: NeilBrown <neilb@suse.de>
To: Thomas Weber <thomas.weber.linux@googlemail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>,
        Thomas Weber <weber@corscience.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] Small fixes for w1_bq27000 driver
Message-ID: <20120219180608.342a8877@notabene.brown>
In-Reply-To: <4F409BAF.9070809@gmail.com>
References: <20120219020910.4958.46866.stgit@notabene.brown>
	<4F409BAF.9070809@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eTDPrfP=0Q3.Y4ObG03mqFs"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eTDPrfP=0Q3.Y4ObG03mqFs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Feb 2012 07:50:23 +0100 Thomas Weber
<thomas.weber.linux@googlemail.com> wrote:

> On 02/19/2012 03:10 AM, NeilBrown wrote:
> > The following three patches fix a problem with the w1 interface for
> > the bq27000 battery charge meter, and remove some unnecessary code.
> >
> > thanks,
> > NeilBrown
> >
> >
> > ---
> >
> > NeilBrown (3):
> >        w1_bq27000: Only one thread can access the bq27000 at a time.
> >        w1_bq27000 - remove w1_bq27000_write
> >        w1_bq27000: remove unnecessary NULL test.
> >
> >
> >   drivers/w1/slaves/w1_bq27000.c |   19 ++-----------------
> >   1 files changed, 2 insertions(+), 17 deletions(-)
> >
> Hello Neil,
> I have the following problem. The board not correctly reads the values=20
> from the bq27000. It also doesn't detects if the bq27000 is connected. I=
=20
> think it always reads 0xFF.
>=20
> Do you have an omap3 board and a bq27000 battery?

Yes, I have an OMAP3 with the HDQ line connected to a battery with a bq27000
in it.  It now works fine.

When I first started working on it I would sometimes get problems with lots
of 0xFF being read, usually with lots of delays.

One problem was that during boot there would often be multiple threads
accessing the battery and tripping over each other.
The third patch of this set fixes that.

The other problem was power saving issues in the OMAP3 drivers.  These
we address with lots of help from Paul Walmsley.

You can find my current set of HDQ patches here:

http://neil.brown.name/git?p=3Dgta04;a=3Dshortlog;h=3Drefs/heads/hdq

 (or git://neil.brown.name/gta04 hdq)

Most of these are from Paul.

Please let me know if they help.

NeilBrown

--Sig_/eTDPrfP=0Q3.Y4ObG03mqFs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0CfYDnsnt1WYoG5AQLyRg//aWfFyzjDd3Rl7KUlPBb+ctObTbkS6pt9
puhPZW/NQPuKfMcaM23Uz0hOjOUaIcVZlEa7A2VBh7s/M1eR8jC3YYWss5czmrNx
YcbNVJBxn20Jf/KS7Hho3eC6OF1l610tg+V9jTaEDrkNF59jyVW/ruFQFkYCJ9UD
SmFMH41wbVWQgZ5+T6m78+82Js51X+Tza8+lAYD/I9XWL1JbiaVMawrYhgfR4K23
4ayTRt52AzM/k1H2VexPt2kJ9/JWPgCw3YTTMF1QfgLeeFxyEMbtYMI+aducdhb8
N8xbAnmQ28B0rt3D7VejZSG4I2lAnOSbV8hfymGpSl9W1DcwWUfQ6jPf4z+lfPVk
ltWT/X4owg31/TUumowcfxKaB8s4b/0s8bEFamtLL3yc+mKODX3B4nger/hG1fXS
iMUG9dQMV3EHGj13xPIzIyB6GJZeTGxp857s2dsTUbi1TLh55adJMEPEiFRgnP9i
DIWGdbI7E/ehjZSPAXhO+nIvd3dfZfbkewWH5VqQFErgVjBql5ArYAKg/Xc9JDAJ
rSKBNbLfC351jy+bTT5KoKbyIEmHbhERA8HH/nod/jCS4gB6w68vEeQ6clMUTei1
pUnVvEBM4+QwtIJuquJU7oZQBFwqR9g33WhF4ti9lwpSOfvUNvdFWDKbcsvZl9Pe
HNtjQ1pMoh8=
=Tmj9
-----END PGP SIGNATURE-----

--Sig_/eTDPrfP=0Q3.Y4ObG03mqFs--
