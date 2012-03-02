Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030544Ab2CBUYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:24:12 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:53157 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756138Ab2CBUYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:24:10 -0500
Date: Fri, 2 Mar 2012 12:24:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: add spinlock held check to
 'pcibios_fwaddrmap_lookup()'
Message-ID: <20120302122405.050ab634@jbarnes-desktop>
In-Reply-To: <20120302200027.GA4817@kroah.com>
References: <20120302194501.26152.22845.stgit@amt.stowe>
	<20120302200027.GA4817@kroah.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QVGSX+fSXxkzpY_ybZsmfvg"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QVGSX+fSXxkzpY_ybZsmfvg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Mar 2012 12:00:27 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Mar 02, 2012 at 12:45:01PM -0700, Myron Stowe wrote:
> > 'pcibios_fwaddrmap_lookup()' is used to maintain FW-assigned BIOS BAR
> > values for reinstatement when normal resource assignment attempts
> > fail and must be called with the 'pcibios_fwaddrmap_lock' spinlock
> > held.
> >=20
> > This patch adds a WARN_ON notification if the spinlock is not currently
> > held by the caller.
> >=20
> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > ---
> >=20
> >  arch/x86/pci/i386.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> > index 33e6a0b..831971e 100644
> > --- a/arch/x86/pci/i386.c
> > +++ b/arch/x86/pci/i386.c
> > @@ -57,6 +57,8 @@ static struct pcibios_fwaddrmap *pcibios_fwaddrmap_lo=
okup(struct pci_dev *dev)
> >  {
> >  	struct pcibios_fwaddrmap *map;
> > =20
> > +	WARN_ON(!spin_is_locked(&pcibios_fwaddrmap_lock));
> > +
>=20
> What is this going to help with?  How can someone then recover from this
> issue?  Just adding a warning message isn't going to fix any problems
> here, why not fix the root cause?

It's just a self-documenting assert; doesn't trigger anything and has
more functionality than
  /* Must hold the fwaddrmap_lock here */


--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/QVGSX+fSXxkzpY_ybZsmfvg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUSxlAAoJEIEoDkX4Qk9hotcQAMv2Rq4j6HAXSJN11wR8NDhe
Ns9MmDLYGkJCL5HLWYDrvwc4yQbYhH4Cty671sBE5+G5XOwGTsIrFZ1w4A+jcVuv
Hj2OkGjWfF78l5aZfMrLvpukDUdU+hTLBvlVmkgsDgzNyvwRDYwq/bWPXl5Tswc/
duTpCvyh5sxF+HJSvnbE0WdkfgtTebyRgCbMJZGVUM8N97uFzLxxH277PHlNaUwt
J/2vI1C2LT1J5iyg9foKlCXqxm4WoebUFdqw0F0Z6fwK1HErCe948y/Hdox3Jq5E
XU3GvRhDbOQnhXLxgVu4YcTpBswHwpWtVfR5NSr3tMUMcfYgS81KE/UxpWquTDzF
fIkjoN+DtVUDsudaEjLvbWrSIIE51jlV7w0rxXG5AVt/5mmWyasVZosICNWcO7Dw
Dysht2DT6IEl2Lutj11mVtFnQMI6i/svZRGAxwkPYMCWoldQ2HLBsub/x84qKdOa
QBSH54ArdDDQKw7y9ATV4kMx1mTsIEo8wHaD7ZmUiPClNMBiuJvXSaq1maRLupgG
2g4q3vT749KXUizAxarTg4HcKp+3O2sYlz0RwG+RFplRZs2mzH38XzwvJN3Jlfgq
PclfKxLXMCComHp9fTNes2QSVOZdPEYhEBAS0df2a+03QxhqVZrehZBQyQa0Kx22
mWamW22l89pEYhQQXu2z
=NPgZ
-----END PGP SIGNATURE-----

--Sig_/QVGSX+fSXxkzpY_ybZsmfvg--
