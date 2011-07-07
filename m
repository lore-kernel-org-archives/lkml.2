Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1GGBAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 21:00:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54623 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1GGBAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 21:00:41 -0400
Date: Thu, 7 Jul 2011 11:00:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org
Subject: Re: [PATCH] PCI: conditional resource-reallocation through kernel
 parameter pci=realloc
Message-Id: <20110707110032.226a16c3b553de67125cf70b@canb.auug.org.au>
In-Reply-To: <20110706090733.1158d959@jbarnes-desktop>
References: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
	<20110706090638.GA29266@ram-ThinkPad-T61>
	<20110706090733.1158d959@jbarnes-desktop>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jul_2011_11_00_32_+1000_gRZJ.zOU/.3jMb3s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jul_2011_11_00_32_+1000_gRZJ.zOU/.3jMb3s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Wed, 6 Jul 2011 09:07:33 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> w=
rote:
>
> On Wed, 6 Jul 2011 02:06:38 -0700
> Ram Pai <linuxram@us.ibm.com> wrote:
>=20
> > On Thu, Jun 30, 2011 at 01:09:39AM -0700, Ram Pai wrote:
> > > Multiple attempts to dynamically reallocate pci resources have unfort=
unately
> > > lead to regressions. Though we continue to fix the regressions and fi=
ne tune the
> > > dynamic-reallocation behavior, we have not reached a acceptable state=
 yet.
> > >=20
> > > This patch provides a interim solution. It disables dynamic-reallocat=
ion; by
> > > default, with the ability to enable it through pci=3Drealloc kernel c=
ommand line
> > > parameter.
> >=20
> > >=20
> > > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > > ---
> > >  Documentation/kernel-parameters.txt |    2 ++
> > >  arch/x86/pci/common.c               |    4 ++++
> > >  drivers/pci/setup-bus.c             |    7 +++++++
> > >  include/linux/pci.h                 |    2 ++
> > >  4 files changed, 15 insertions(+), 0 deletions(-)
> > >=20
> > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kern=
el-parameters.txt
> > > index fd248a3..aa47be7 100644
> > > --- a/Documentation/kernel-parameters.txt
> > > +++ b/Documentation/kernel-parameters.txt
> > > @@ -2015,6 +2015,8 @@ bytes respectively. Such letter suffixes can al=
so be entirely omitted.
> > >  				the default.
> > >  				off: Turn ECRC off
> > >  				on: Turn ECRC on.
> > > +		realloc		reallocate PCI resources if allocations done by BIOS
> > > +				are erroneous.
> > >=20
> > >  	pcie_aspm=3D	[PCIE] Forcibly enable or disable PCIe Active State Po=
wer
> > >  			Management.
> >=20
> > Linus/Jesse,
> >=20
> > 	Are we merging this patch in 3.0.0 ?
>=20
> Yeah I think we probably should, since the alternative is still pretty
> large.
>=20
> I'll queue it up with any other small patches that are needed at this
> point and send them over to Linus.

It breaks the powerpc build (see my other message).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jul_2011_11_00_32_+1000_gRZJ.zOU/.3jMb3s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFQUwAAoJEDMEi1NhKgbsQQIH/ROHg5XtdEyEGlwVWhh5CPDN
C6nkiZa08LOTlBYE/cHKbNDnVuMvpDD69thaC+KNPVnwiyscLpngVOojjnogPCMm
xerfSLFNUsaNj0kTjePor9AIjKZzYeSGjsZogYzXgAMBwIG0E2Oxgx9duoDeR6lu
sTMP5qSPKAc/q2KHxVZQHg04qffWsADHQMg4dZBcQibXOOOj14BS5Uoyvcbuwvmv
Frn5j6l7iQdUPEerfYEuAtTBXxQTJTUzBYLibFKEVQeX0+Rm9Tt8dWFojpXSuqS5
9LTGFdW86Yx5m/8DXQev3kZ4OzzICjqxJo853IzYUDegDVuAgtB2fOdRXAnGXOU=
=kVvh
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jul_2011_11_00_32_+1000_gRZJ.zOU/.3jMb3s--
