Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2IRSOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:14:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2IRSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:14:51 -0400
Date: Tue, 18 Sep 2012 20:14:39 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: pci: Keep pci_common_init() around after init
Message-ID: <20120918181439.GB29360@avionic-0098.mockup.avionic-design.de>
References: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
 <1347657078-32230-2-git-send-email-thierry.reding@avionic-design.de>
 <CAErSpo7bix_4bayh2ha_yogwNiLACU7Bymd_H5ur1wxF-tmTNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <CAErSpo7bix_4bayh2ha_yogwNiLACU7Bymd_H5ur1wxF-tmTNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4BlVzCH8wukh/GAklKM9l5GlVGC/EcPCG2y/cSlHLfd
 miF/CwyeHo20Eb+Fj+2KnrYgF9r70P62c5KTWurR0mR9emRFgo
 d9m/N6/K9L//hid7kDntsi6U2KbOnZIzxJX2quKMKktFgMFPey
 PbGqsyjQGGa2TynTQ5FQeglO3V17r6rOiVB0zD7ptpRYlK0cWA
 3TwPGFpT3FxU6jEAfT9RlAlzDT3MdmR1/gh1cPpmQVrU+bOcQ9
 yxrcy3Keibbc6xXaixBWccZr4NjKfm/vlxBVSLTghJFpAqaTSz
 6Sdgv7rRiRG6y4ORiuCe029fiRthLfrR05phZA+3ztOHwq5hOk
 tDedgeVXYkj9iVGXjQcqWx2Y7hRWA/N1pSRRKB/nXi9gUiQi6S
 /3yg8FtiwLu2FapE/0MgFoIxr0BHdvARco=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2012 at 11:13:23AM -0600, Bjorn Helgaas wrote:
> On Fri, Sep 14, 2012 at 3:11 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > When using deferred driver probing, PCI host controller drivers may
> > actually require this function after the init stage.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  arch/arm/kernel/bios32.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> > index 2b2f25e..7288093 100644
> > --- a/arch/arm/kernel/bios32.c
> > +++ b/arch/arm/kernel/bios32.c
> > @@ -423,7 +423,7 @@ static int pcibios_map_irq(const struct pci_dev *de=
v, u8 slot, u8 pin)
> >         return irq;
> >  }
> >
> > -static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head=
 *head)
> > +static void __devinit pcibios_init_hw(struct hw_pci *hw, struct list_h=
ead *head)
>=20
> Shouldn't we just remove __init completely, since Greg KH is in the
> process of removing __devinit?

Yes, we probably should. In fact I have a patch on top of this marked
work-in-progress that I forgot to squash into this. That patch includes
the removal of __devinit for pcibios_update_irq() that should be covered
by a different patch I sent a few days ago as well as pcibios_swizzle()
and pcibios_init_resources(). I'll squash it into this patch and will
resend.

Thierry

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWLoPAAoJEN0jrNd/PrOhynsP/AlWw3ExzFeHXqxVsqO8sl4y
brzglGkAo50rBNMWG/Cuvry+g2GKGmKRN8DN+v78EafaemLHZb9ZqwOajMyxs45T
rP6TCwsPDs4MIinrLl+wby3Q9pKZu8AgJR4V209+0ou+wW8sRjWSig33Cg2KBAGQ
UsFa4LzX+WJtoYYgcYGp/JG3u5DwayGcJyN9Gu1AGnB227o7E2/0xs4BzGty5r8P
xLKXqCXgvxJNXvfgyMz3zhTlxFdzmQ0L0uL3wbeJPvzSFq2Z8ZxDqISjxRVzEuLN
a8RnbfyLF9k9UOZMldO9OTuuGKl9MThaZ/cfARFkP0Exrn/7Q3nSW2/cRHredTix
tOW+LjOfp10ATQH3H/ViKIyJvfVW4nRV+sywQCYvU4BmlSDWFmurQiPm+OI469ey
ZFnG5N8Y7tfF+mDauWS25QjsmoPtbOukNb9tshn/4r1OdVQZOWiAtsCcikXUBzXf
Qii/74vU/ZrNbEBOZaU2dtUOAMEoPgeCDXojLY7YP5gJeDtRRibd4DLdSm5bm1DU
rryThQ0AAtMV1DDwDuIyYdcVbltw3Pv1X01pDy4f951EuD7Nmz3kq+pZGS9E0dim
SmnFfgXkltFXK97JxVor2TiEPHUY1ZJUjaHO8bd2Y5VZd/QJ4X9EvRBYeaH8BKc+
zRfLzzXrrcnou1DBxAmD
=opLy
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
