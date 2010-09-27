Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab0I0Nb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:31:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50214 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab0I0Nb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:31:26 -0400
Date: Mon, 27 Sep 2010 23:31:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warnings in Linus' tree
Message-Id: <20100927233115.27a5a379.sfr@canb.auug.org.au>
In-Reply-To: <20100917142630.b968977c.sfr@canb.auug.org.au>
References: <20100817112439.18f9d958.sfr@canb.auug.org.au>
	<20100830114222.3a1f53e6.sfr@canb.auug.org.au>
	<1283148482.3707.167.camel@rui>
	<20100917142630.b968977c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Sep_2010_23_31_15_+1000_AjTzLEdK8FCaJ.Hy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Sep_2010_23_31_15_+1000_AjTzLEdK8FCaJ.Hy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Fri, 17 Sep 2010 14:26:30 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 30 Aug 2010 14:08:02 +0800 Zhang Rui <rui.zhang@intel.com> wrote:
> >
> > On Mon, 2010-08-30 at 09:42 +0800, Stephen Rothwell wrote:
> > > Hi Len,
> > >=20
> > > On Tue, 17 Aug 2010 11:24:39 +1000 Stephen Rothwell <sfr@canb.auug.or=
g.au> wrote:
> > > >
> > > > Today's linux-next build (x86_64 allmodconfig) produced these warni=
ngs:
> > > >=20
> > > > drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_o=
ld_set_param' from incompatible pointer type
> > > > include/linux/moduleparam.h:165: note: expected 'int (*)(const char=
 *, struct kernel_param *)' but argument is of type 'int (*)(const char *, =
const struct kernel_param *)'
>=20
> [several more elided]
>=20
> > > > Introduced by commit 1c8fce27e275fd7c6b75bc6455745f02d3903ee6 ("ACP=
I:
> > > > introduce drivers/acpi/sysfs.c") interacting with commit
> > > > 9bbb9e5a33109b2832e2e63dcc7a132924ab374b ("param: use ops in struct
> > > > kernel_param, rather than get and set fns directly").
> > >=20
> > > Can we have this fixed, please?
> > patch attached. :)
> >=20
> > Use module_param_cb instead of the obsoleted module_param_call to fix a=
 build warning.
> >=20
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>=20
> Now that this has been in linux-next since Sep 6, can you please send it
> to Linus.  It removes quite a few warnings that were introduced during
> this merge window - and I think we already have too many warnings.

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Sep_2010_23_31_15_+1000_AjTzLEdK8FCaJ.Hy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMoJyjAAoJEDMEi1NhKgbsUl4IAIBK8u8SsjAR5QX2b8OP6ItC
U7/scfLbC7xz//Cvk/fEfu7MpbOYzPXg7xiHPoun7yQ6U6+lwCpY2odm7WZms/PP
NgbHM/DnuSKUpwWg3utNlHX/F2Psl2aEupDnw0ICoAWK5UwFUJ4mRDuKTCAxyV1G
n8fytJxnvQ4V2ipxqHa6FvEyOX0Y996S3xmaP53ANruvX7DrPbPHnNNS8/VWXNaW
yj0oI3We3jhE7xXEOjZkm5eHYAXM27nuubI0sxNKSaH3hzffmQwHrIacv4CDzuca
ZRQ+fSwGBYZuX1XqwmsSVz4F/EVfXrAVDPinIQZ5lRr5cCYH/9PQoF/hrqoErW8=
=ZbnJ
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Sep_2010_23_31_15_+1000_AjTzLEdK8FCaJ.Hy--
