Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0KYNbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:31:32 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:54311 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab0KYNbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:31:31 -0500
X-Spam-ASN: 
Date: Thu, 25 Nov 2010 16:30:35 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Alan Cox <alan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 05/17] tty: don't allow ldisc dcd_change() after ldisc
 halt
Message-ID: <20101125163035.3105747b@desktopvm.lvknet>
In-Reply-To: <20101124223600.5eb8476f@bob.linux.org.uk>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
	<48e935cac42ae455e2ef8fc45f7eef7631eece6b.1290599844.git.lasaine@lvk.cs.msu.su>
	<20101124164329.75368d71@lxorguk.ukuu.org.uk>
	<20101125013812.0dc828ad@tornado.gnet>
	<20101124223600.5eb8476f@bob.linux.org.uk>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/wgTRNhBtqDFrsih4R6+MKM="; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wgTRNhBtqDFrsih4R6+MKM=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 24 Nov 2010 22:36:00 +0000
Alan Cox <alan@linux.intel.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> > Yes, indeed, it's a bug. Please consider the following example:
> >=20
> >      CPU1                                      CPU2
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > uart_handle_dcd_change() {		tty_set_ldisc() {
> >   ld =3D tty_ldisc_ref(...)			  ...
>=20
> [We have a reference]
> >   ...					  tty_ldisc_halt(...)
> 					  [Should block]
>=20
> > I think tty code is exactly the right place to fix this bug; this is
> > what my patch is for.
>=20
> More special case magic on top of the current crap isn't the right fix
> here, tty_ldisc_halt needs to wait for the references to hit zero.

Didn't know that current design is crap. :)
Ok, I think I'll add a new waitqueue and a new bit (TTY_LDISC_NOREF)
that halt will wait for. Is it good?

--=20
  Alexander

--Sig_/wgTRNhBtqDFrsih4R6+MKM=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM7mT7AAoJEElrwznyooJbPfgH/1yUl4skkIYu69quNppuWiVY
xo72NIeGiBGLXUhPTS5zE5dWvs/gMOMi5gnRfixv+a/NfI6bYF+6vikvRT2Aj+nF
KHz7mmNTN8Fzq6CMdH2kFPl4R2cgpAVotXLXnP/+zriwOUbTKKuwHMOeYAO15jCR
25CynGvJOXY2ZTpdUobQA9sQgwekv+gno45Yt198ZrSE1WrynYKPy4VrDVqZ7LOX
gxEMVfDcqrHAq7Auf87AEzWYiKKFy/gmhyQR+C/4qgV8tKYww6YTsXDPNkwIlELc
x2CrXkpbIeQWpYz1SRgAP9yckn9r4eAXJ658Zng4sHBDIWNCuWtIwvFWCqFfZ0M=
=iYDR
-----END PGP SIGNATURE-----

--Sig_/wgTRNhBtqDFrsih4R6+MKM=--
