Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab2CBRZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:25:54 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:57140 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757809Ab2CBRZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:25:51 -0500
Date: Fri, 2 Mar 2012 09:25:45 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] Dynamically add and remove device specific reset
 functions
Message-ID: <20120302092545.1719e6f2@jbarnes-desktop>
In-Reply-To: <CAErSpo6QzCy7cgN8boXu4zhGhTbjEG7RyJ6avaVKL_u=vGMOUw@mail.gmail.com>
References: <4f50b540.6AzyOmpHR+z7jLk1%tadeusz.struk@intel.com>
	<CAErSpo6JaNXvJf_KEkRUYLed8ET4vSunfCAq9BWq3yd3+dZQpA@mail.gmail.com>
	<4F50FE1B.7090008@intel.com>
	<CAErSpo6QzCy7cgN8boXu4zhGhTbjEG7RyJ6avaVKL_u=vGMOUw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5sxVu0prx8ORJuoZFiVIxUa"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5sxVu0prx8ORJuoZFiVIxUa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Mar 2012 10:17:53 -0700
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Fri, Mar 2, 2012 at 10:06 AM, Tadeusz Struk <tadeusz.struk@intel.com> =
wrote:
> > On 02/03/12 16:29, Bjorn Helgaas wrote:
> >> Where do you plan to add calls to pci_dev_specific_reset_add()? =C2=A0=
In
> >> drivers?
> >
> > Yes, I'm working on a driver for a device with SRIOV capability.
> > I'll call it from there.
> >
> >> Did you consider adding a "reset" function pointer to struct
> >> pci_driver? =C2=A0That might be more natural -- the reset function is =
right
> >> with all the other code that knows about the device, and there's no
> >> issue with looking up the correct reset function.
> >> With this patch, we sort of have two different ways to map
> >> vendor/device IDs to code: the usual pci_register_driver() approach,
> >> and this one using reset_list. =C2=A0If pci_driver had a "reset" point=
er,
> >> that would be used most of the time. =C2=A0You might still need the
> >> reset_list for generic things, e.g., the reset_intel_generic_dev()
> >> function, but it would be a fallback. =C2=A0It might look something li=
ke:
> >>
> >> =C2=A0 =C2=A0 struct pci_driver *drv =3D dev->driver;
> >>
> >> =C2=A0 =C2=A0 if (drv && drv->reset) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 drv->reset(dev);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> >> =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 list_for_each_entry(i, &reset_list, list) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ...
> >
> > No, I didn't think about it.
> > This is good idea, but for me the pci_dev_specific_reset() works fine.
>=20
> I know your patch works fine, but I think we should have the
> discussion about whether adding a struct pci_driver pointer is a
> better long-term solution.
>=20
> Greg, Jesse, others, chime in if you have any thoughts.

I thought we had one already... /me digs around.  Ah just for AER and
platform error handling.

I do like the idea of a driver hook here; I think there are quite a few
devices that can be reset w/o FLR and that may need additional
handling, so there's an opportunity to consolidate code.

I think it would probably make Tadeusz's patch smaller too; he could
just add the hook and a function for his driver, then conversions for
existing code could come later.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/5sxVu0prx8ORJuoZFiVIxUa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUQKZAAoJEIEoDkX4Qk9h2skP/14UUO6dEfvXdtU7skOIxpwE
bT5DyYvj3bduVxAGjWmgO5cMbBELH+aulUy1RSbWnSaa5WvPpQgNaFOuzZ7zTqB1
Lmc5KF18VtUhvHrtyQWeBOIhwOaO8W+VubLVxpRajzQqTxrCQTbaAM0sqyjkpioH
0qvsRKl/TElg/5PKJojQXtIQB7g/koehb9/NMbN43sGLN0V2KLgYYtO3dDPXqEyi
0qKzy1YsGIAsQbe2eWffPLZcHZCaZV6shdeCU2Ee0eJjNqQioCg7XI3erQnaj1Fh
kYGdizsYk3VjNgalelTcnLw2VHpJmch/kQJ+ueUdleZfmpt+34nC2ZuChItqqjmn
y9HIPt5rA/fidseFutzUH/x8vCoJXy3gIx6VuBZJuVoOxy8ZEnDZpQoiTcYG9irG
KYvauQ7RNv62obXET5oG/kD+G+0nd7Q/pu3SaAwUSqvKRdbp74F38I/pNH7TQLSF
sDRlKE0vKp/rXsyEBM1LBWt3HT13eeoo75UTJwpbNIOSx/uUhSVUenIZ6I3dkgDt
xgwxiCr1gZV9wcxUCdkei5KVs41f92CGm1lKtFKaqfnuyV7hB3eq9GMSnk9iuj0H
//YURHK7m2PeEMWjTr03yvie5jM4/KWd34Zh+PhGrlrvNIWsT9zfrxFxWbBGsiTV
FneRi1uUKsRSlisyb7Ib
=d3xo
-----END PGP SIGNATURE-----

--Sig_/5sxVu0prx8ORJuoZFiVIxUa--
