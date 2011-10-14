Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1JNILq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 04:11:46 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:44863 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1JNILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 04:11:44 -0400
Date: Fri, 14 Oct 2011 02:11:43 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v14] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <CAP05o4JAuCtj_i=Nye2afV8vv23i=qC0zO4a7sYP+hcn3QqHnA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110140205460.16865@utopia.booyaka.com>
References: <1318319355-20168-1-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1110131227270.24155@utopia.booyaka.com> <alpine.DEB.2.00.1110131857350.24155@utopia.booyaka.com> <CAP05o4JAuCtj_i=Nye2afV8vv23i=qC0zO4a7sYP+hcn3QqHnA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-550661757-1318579617=:16865"
Content-ID: <alpine.DEB.2.00.1110140207040.16865@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-550661757-1318579617=:16865
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1110140207041.16865@utopia.booyaka.com>

Hi

On Fri, 14 Oct 2011, Munegowda, Keshava wrote:

> On Fri, Oct 14, 2011 at 6:33 AM, Paul Walmsley <paul@pwsan.com> wrote:

> > =A0static __initdata struct omap_hwmod *omap3xxx_hwmods[] =3D {
> > =A0 =A0 =A0 =A0&omap3xxx_l3_main_hwmod,
> > =A0 =A0 =A0 =A0&omap3xxx_l4_core_hwmod,
> > @@ -3151,6 +3365,7 @@ static __initdata struct omap_hwmod *omap3xxx_hwm=
ods[] =3D {
> > =A0 =A0 =A0 =A0&omap3xxx_uart1_hwmod,
> > =A0 =A0 =A0 =A0&omap3xxx_uart2_hwmod,
> > =A0 =A0 =A0 =A0&omap3xxx_uart3_hwmod,
> > +
>=20
> why you have removed  &omap3xxx_usb_host_hs_hwmod,
> and       &omap3xxx_usb_tll_hs_hwmod.?

I have removed them because, according to the OMAP3430 ES1.0 Revision A=20
TRM (SWPU100A), the HS USBHOST subsystem is not present on OMAP3430 ES1.0. =
=20
Therefore the HS USBHOST modules must not be marked as being common to all=
=20
OMAP3xxx chips in the hwmod data.

If you have information that indicates that it's present on OMAP3430=20
ES1.0, please let me know ASAP.

> I think it is required here, please let me know.
>=20
> regards
> keshava
>=20
>=20
>=20
>=20
> > =A0 =A0 =A0 =A0/* dss class */
> > =A0 =A0 =A0 =A0&omap3xxx_dss_dispc_hwmod,
> > =A0 =A0 =A0 =A0&omap3xxx_dss_dsi1_hwmod,
> > @@ -3206,6 +3421,8 @@ static __initdata struct omap_hwmod *omap3430es1_=
hwmods[] =3D {
> > =A0static __initdata struct omap_hwmod *omap3430es2plus_hwmods[] =3D {
> > =A0 =A0 =A0 =A0&omap3xxx_dss_core_hwmod,
> > =A0 =A0 =A0 =A0&omap3xxx_usbhsotg_hwmod,
> > + =A0 =A0 =A0 &omap3xxx_usb_host_hs_hwmod,
> > + =A0 =A0 =A0 &omap3xxx_usb_tll_hs_hwmod,
> > =A0 =A0 =A0 =A0NULL
> > =A0};
> >
> > @@ -3223,12 +3440,16 @@ static __initdata struct omap_hwmod *omap36xx_h=
wmods[] =3D {
> > =A0 =A0 =A0 =A0&omap36xx_sr1_hwmod,
> > =A0 =A0 =A0 =A0&omap36xx_sr2_hwmod,
> > =A0 =A0 =A0 =A0&omap3xxx_usbhsotg_hwmod,
> > + =A0 =A0 =A0 &omap3xxx_usb_host_hs_hwmod,
> > + =A0 =A0 =A0 &omap3xxx_usb_tll_hs_hwmod,
> > =A0 =A0 =A0 =A0NULL
> > =A0};
> >
> > =A0static __initdata struct omap_hwmod *am35xx_hwmods[] =3D {
> > =A0 =A0 =A0 =A0&omap3xxx_dss_core_hwmod, /* XXX ??? */
> > =A0 =A0 =A0 =A0&am35xx_usbhsotg_hwmod,
> > + =A0 =A0 =A0 &omap3xxx_usb_host_hs_hwmod,
> > + =A0 =A0 =A0 &omap3xxx_usb_tll_hs_hwmod,
> > =A0 =A0 =A0 =A0NULL
> > =A0};
> >
> > --
> > 1.7.7
> >
> >
>=20


- Paul
--155748971-550661757-1318579617=:16865--
