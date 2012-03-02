Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026Ab2CBVJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:09:44 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:41567 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755640Ab2CBVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:09:42 -0500
Date: Fri, 2 Mar 2012 13:09:34 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: add spinlock held check to
 'pcibios_fwaddrmap_lookup()'
Message-ID: <20120302130934.1dceca8b@jbarnes-desktop>
In-Reply-To: <20120302204136.GB24752@kroah.com>
References: <20120302194501.26152.22845.stgit@amt.stowe>
	<20120302200027.GA4817@kroah.com>
	<20120302122405.050ab634@jbarnes-desktop>
	<20120302204136.GB24752@kroah.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+LoprM_kDg2S+okOI_yyxKn"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+LoprM_kDg2S+okOI_yyxKn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Mar 2012 12:41:36 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Mar 02, 2012 at 12:24:05PM -0800, Jesse Barnes wrote:
> > On Fri, 2 Mar 2012 12:00:27 -0800
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> >=20
> > > On Fri, Mar 02, 2012 at 12:45:01PM -0700, Myron Stowe wrote:
> > > > 'pcibios_fwaddrmap_lookup()' is used to maintain FW-assigned BIOS B=
AR
> > > > values for reinstatement when normal resource assignment attempts
> > > > fail and must be called with the 'pcibios_fwaddrmap_lock' spinlock
> > > > held.
> > > >=20
> > > > This patch adds a WARN_ON notification if the spinlock is not curre=
ntly
> > > > held by the caller.
> > > >=20
> > > > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > > > ---
> > > >=20
> > > >  arch/x86/pci/i386.c |    2 ++
> > > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > >=20
> > > > diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> > > > index 33e6a0b..831971e 100644
> > > > --- a/arch/x86/pci/i386.c
> > > > +++ b/arch/x86/pci/i386.c
> > > > @@ -57,6 +57,8 @@ static struct pcibios_fwaddrmap *pcibios_fwaddrma=
p_lookup(struct pci_dev *dev)
> > > >  {
> > > >  	struct pcibios_fwaddrmap *map;
> > > > =20
> > > > +	WARN_ON(!spin_is_locked(&pcibios_fwaddrmap_lock));
> > > > +
> > >=20
> > > What is this going to help with?  How can someone then recover from t=
his
> > > issue?  Just adding a warning message isn't going to fix any problems
> > > here, why not fix the root cause?
> >=20
> > It's just a self-documenting assert; doesn't trigger anything and has
> > more functionality than
> >   /* Must hold the fwaddrmap_lock here */
>=20
> Don't we have sparse markups that we can use to verify this instead
> somehow?  Adding asserts isn't the nicest, as what will a user really do
> about this if it ever gets hit?  And if a user isn't supposed to do
> anything, then yes, a comment would be best I would think.

The user is supposed to report a bug, but it likely won't cause a
crash, just a worrying message in the log.

And yeah I think we have some sparse bits for this, and at one point I
thought we had an assert_spin_is_locked or somesuch.

I like the idea of self-documenting code checks better than just
comments.  Sparse annotations are a good second solution, but not as
nice since sparse isn't always run, and has a harder time with control
flow dependent stuff like this.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/+LoprM_kDg2S+okOI_yyxKn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUTcOAAoJEIEoDkX4Qk9h7D0P+QFntwMSrv3sVpfGLIEMHQ+n
u4QVik3FRkVDSsY2RZJIBPabxWM7rReNHy1pU3wDuCJJfEqbbBM+/sbIROmTpUEQ
NXTq7rN/fjGNKP+l3Aevs4wufNQz+nmgFQe1mJ/eL8w/Uq0NLiFSPCdg03lDtbfz
aLvnn9ahyFaB8enSNTM2ideOYJKfm78Z4LEhc05NWLG0DXYHb1TW1ue7p5JMaOwc
UhgZtYhFr51HyU5AyPhdB2MG+jMRTBltnscaSOBPyB6T9PZrEIJ2QAMnWOAt8GFm
Ij8m3gAHfxEwOdScHppOYrz84DrOHQtrfLpmlUQQOZxz13Cxp8gKQjN41KpPGZu8
/qWpNG96pprUXY4QcUat9+qg2JR/cYfbV6XX1a1LLJyhIhrTpF/4yls1Bi0ZgMVE
4J2kZfUwWM3MGCXeSGzbmNdd03OVftyGZZEoZb8QwCto1jaYjMgOwkrCZI/n0cPM
WFt0uOlq5pwSB8wS1f0OXAUbhdPen86GQ+78P15ENl7Ms+pQoMuREM17uQ6tKPt7
UsPDgP+EOcEZzXGSnC35+bQbP/IYn3ZzFHxIAd9feaFdlrHt8l7sefNcjc7JmKo4
VSX98lH/cYdkojfhF3+A2ePM+752DSWZiJcXaYAggLHAcoi6Uf1zXqr1VmFSNpGl
8Ksh4E+WbxpGAxlVNsXu
=Jovo
-----END PGP SIGNATURE-----

--Sig_/+LoprM_kDg2S+okOI_yyxKn--
