Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab1IXHPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 03:15:05 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:46726 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1IXHPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 03:15:03 -0400
Date: Sat, 24 Sep 2011 01:15:01 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        b-cousson@ti.com, balbi@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        tony@atomide.com, khilman@ti.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109240101120.22872@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
 <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-1671404457-1316848501=:22872"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-1671404457-1316848501=:22872
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 23 Sep 2011, Munegowda, Keshava wrote:

> On Thu, Sep 22, 2011 at 11:31 PM, Paul Walmsley <paul@pwsan.com> wrote:
> >
> > On Thu, 22 Sep 2011, Keshava Munegowda wrote:
> >> 4. usb_tll_hs hwmod of usbhs with the TLL base address and irq.
> >>
> >> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> >> Reviewed-by: Partha Basak <parthab@india.ti.com>
> >> ---
> >> =A0arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | =A0271 +++++++++++++++=
+++++++++++++
> >> =A01 files changed, 271 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mac=
h-omap2/omap_hwmod_3xxx_data.c
> >> index 59fdb9f..d79f728 100644
> >> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> >> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c

> >> +static struct omap_hwmod_ocp_if omap34xx_f128m_cfg__usb_host_hs =3D {
> >> + =A0 =A0 .clk =A0 =A0 =A0 =A0 =A0 =A0=3D "usbhost_120m_fck",
> >
> > This doesn't look right. =A0This is an interface structure record, so i=
t
> > should be associated with an interface clock. =A0Is the hardware really
> > using the functional clock as the interface clock? =A0Or, as seems more
> > likely...
>=20
>=20
> Agreed, how about:
>=20
> main clock: usbhost_120m_fck
> optional f clock: usbhost_48m_fck

Assuming the interface clock is enabled, which one of these clocks is=20
needed for UHH register accesses to complete successfully?

> interface clock: usbhost_ick.
>=20
>=20
>=20
> >> + =A0 =A0 .user =A0 =A0 =A0 =A0 =A0 =3D OCP_USER_MPU,
> >> + =A0 =A0 .flags =A0 =A0 =A0 =A0 =A0=3D OCPIF_SWSUP_IDLE,
> >
> > ... is this just a hack? =A0OCPIF_SWSUP_IDLE is intended to work around
> > hardware autoidle bugs only. =A0Are you sure this shouldn't be defined =
as an
> > optional clock instead?
>=20
> yes ! it was causeing resets, hence you this flag.

usbhost_120m_fck is not an interface clock.  That is probably what was
causing the problem you describe.

> >> +static struct omap_hwmod omap34xx_usb_host_hs_hwmod =3D {
> >> + =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =3D "usb_host_hs",
> >> + =A0 =A0 .class =A0 =A0 =A0 =A0 =A0=3D &omap34xx_usb_host_hs_hwmod_cl=
ass,
> >> + =A0 =A0 .main_clk =A0 =A0 =A0 =3D "usbhost_ick",
> >
> > Is this really the main clock? =A0The main clock is the clock that driv=
es
> > the register logic in the IP block. =A0Looks to me, based on the integr=
ation
> > document in the 34xx TRM vZR, that this module has a functional clock. =
=A0In
> > general, the only time that the main_clk should be an interface clock i=
s
> > when the clock is a combined interface and functional clock. =A0The mai=
lbox
> > IP block is a classic example.
>=20
> As I mentioned above;  I can make
>=20
> main clock: usbhost_120m_fck
> optional f clock: usbhost_48m_fck
> interface clock: usbhost_ick.
>=20
> do you agree?

The interface clock should definitely be usbhost_ick, no doubt about it.

But, as I mentioned above, to determine which functional clock should be=20
the main clock, you first need to know which of those two clocks need to=20
be enabled for register accesses to that module to succeed.

I did this work a few years ago, by trial and error since it was largely=20
undocumented.  It was needed since the OMAP3 clk_enable() code waits for=20
the PRCM to request that the IP block exit idle before returning. =20
You might want to take a look at arch/arm/mach-omap2/clock3xxx_data.c.

> >> +static struct omap_hwmod omap34xx_usb_tll_hs_hwmod =3D {
> >> + =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =3D "usb_tll_hs",
> >> + =A0 =A0 .class =A0 =A0 =A0 =A0 =A0=3D &omap34xx_usb_tll_hs_hwmod_cla=
ss,
> >> + =A0 =A0 .mpu_irqs =A0 =A0 =A0 =3D omap34xx_usb_tll_hs_irqs,
> >> + =A0 =A0 .main_clk =A0 =A0 =A0 =3D "usbtll_ick",
> >
> > Is this really the main clock? =A0The main clock is the clock that driv=
es
> > the register logic in the IP block. =A0Looks to me, based on the integr=
ation
> > document in the 34xx TRM vZR, that this module has a functional clock.
>=20
> I can make
>=20
> main clock: usbtll_fck
> interface clock: usbtll_ick.
>=20
> do you agree?

Doesn't that make more sense?


- Paul
--155748971-1671404457-1316848501=:22872--
