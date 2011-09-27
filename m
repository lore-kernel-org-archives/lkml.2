Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1I0NZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:25:05 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:32872 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609Ab1I0NZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:25:03 -0400
Date: Tue, 27 Sep 2011 16:24:56 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: t-kristo@ti.com, Paul Walmsley <paul@pwsan.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Basak, Partha" <p-basak2@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gadiyar, Anand" <gadiyar@ti.com>, sameo@linux.intel.com,
        tony@atomide.com, "Hilman, Kevin" <khilman@ti.com>,
        johnstul@us.ibm.com, "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
Message-ID: <20110927132453.GF19603@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
 <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
 <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com>
 <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
 <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
 <alpine.DEB.2.00.1109240020510.22872@utopia.booyaka.com>
 <CAP05o4Lwk2uUz5ou84GQsrsBdjW-FEYP-55pBzH+a74hP4g1Dw@mail.gmail.com>
 <cbad72cea703d117067f7c628f7db806@mail.gmail.com>
 <1317127327.3820.31.camel@sokoban>
 <CAP05o4J75jGLTH8prOGD79Mte4DOg9ukgwe3V-KHFnB1Q-fi4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Ow488MNN9B9o/ov"
Content-Disposition: inline
In-Reply-To: <CAP05o4J75jGLTH8prOGD79Mte4DOg9ukgwe3V-KHFnB1Q-fi4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1Ow488MNN9B9o/ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 27, 2011 at 06:48:35PM +0530, Munegowda, Keshava wrote:
> > So, you would need a mechanism to do something like this:
> >
> > pad a or b wakeup detected -> irq0
> > pad c or d wakeup detected -> irq1?
>=20
> yes, if get something like this , its perfect.

can't you have different IRQs for each pad ? I mean, allocate one
irq_desc for each pad and let drivers request a pad/pin as an IRQ
source. Then, when you detect a pad wakeup, you can:

unsigned	pad_irq =3D pad_number - pad->irq_base;

handle_nested_thread(pad_irq);

this will make use of threaded IRQ handlers even. Could it be something
like that ?

--=20
balbi

--1Ow488MNN9B9o/ov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgc6lAAoJEAv8Txj19kN1hPcIAKj/kqa/tVrOv82HiZXJUZcd
l91W7iMH9Bhm7IhyOxlCsd6qP2EW8XAqvP6FE1ajEdNM1qWwzbJfI7tGQnil3Cu6
KZUi1q83Ao7P9L7hV+caiMuNi/O/ukbSfO4S8joeAkrqxeED8T6An/vxlfwM410c
pqasOEC4kB2Ehh+896VEGI/3WDIOz3Yk70QU4/5PdngxCvktTJ36K4dRyOv+stbx
4PKswoxHZCvTN930v7Pblz0q5lm54E2GazN0lRUz/yQRFSVUKO3+CVyQBFzXoKbn
RPnFQqv0F+Ozf+bUukUNiuFjDiq5vxYJhVrv447yGd6PVdtHh8cNk8zyCBra/HI=
=9gGW
-----END PGP SIGNATURE-----

--1Ow488MNN9B9o/ov--
