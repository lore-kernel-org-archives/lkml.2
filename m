Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2IYJQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:16:13 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:42804 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751790Ab2IYJQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:16:10 -0400
Date: Tue, 25 Sep 2012 12:11:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, "Poddar, Sourav" <sourav.poddar@ti.com>,
        gregkh@linuxfoundation.org, khilman@ti.com, paul@pwsan.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
 suspended.
Message-ID: <20120925091112.GK9137@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
 <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
 <20120925083029.GG31374@n2100.arm.linux.org.uk>
 <20120925083118.GI9137@arwen.pp.htv.fi>
 <20120925091228.GI31374@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0FM4RQAc0jwHekq5"
Content-Disposition: inline
In-Reply-To: <20120925091228.GI31374@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0FM4RQAc0jwHekq5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 25, 2012 at 10:12:28AM +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 25, 2012 at 11:31:20AM +0300, Felipe Balbi wrote:
> > On Tue, Sep 25, 2012 at 09:30:29AM +0100, Russell King - ARM Linux wrot=
e:
> > > How is this happening?  I think that needs proper investigation - or =
if
> > > it's had more investigation, then the results needs to be included in
> > > the commit description so that everyone can understand the issue here.
> > >=20
> > > We should not be resuming a device which hasn't been suspended.  Maybe
> > > the runtime PM enable sequence is wrong, and that's what should be fi=
xed
> > > instead? =20
> > >=20
> > > This sequence in the probe() function:
> > >=20
> > >         pm_runtime_irq_safe(&pdev->dev);
> > >         pm_runtime_enable(&pdev->dev);
> > >         pm_runtime_get_sync(&pdev->dev);
> > >=20
> > > would enable runtime PM while the s/w state indicates that it's disab=
led,
> > > and then that pm_runtime_get_sync() will want to resume the device.  =
See
> > > the section "5. Runtime PM Initialization, Device Probing and Removal"
> > > in Documentation/power/runtime_pm.txt, specifically the second paragr=
aph
> > > of that section.
> >=20
> > that was tested. It worked in pandaboard but didn't work on beagleboard
> > XM. Sourav tried to start a discussion about that, but it simply died...
> >=20
> > In any case, pm_runtime_get_sync() in probe will always call
> > runtime_resume callback, right ?
>=20
> Well, if the runtime PM state says it's suspended, and then you enable
> runtime PM, the first call to pm_runtime_get_sync() will trigger a resume
> attempt.  The patch description is complaining about resume events without
> there being a preceding suspend event.
>=20
> This could well be why.

that's most likely, of course. But should we cause a regression to
beagleboard XM because of that ? Also, if you look into chapter 9 of the
runtime_pm documentation, starting on line 822 you'll see documentation
suggests the use of mystruct->is_suspended flag.

--=20
balbi

--0FM4RQAc0jwHekq5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQYXUwAAoJEIaOsuA1yqREeIEQAI47J7e2DJkfVPN42AKLJHql
sEK9T60eGehG6SJSWUjwz3NH4aOapDX50oBduPsLy18FbjTHGS9dcmIIP7BxhE/3
xMGAtCNBS5OVUTBPVf1zWtuezmdfZwKAo9E19+5b5SlfguHzKtJfWj22UA6jL7RO
v2o19NnBFiZhNgedIQ8LrrBq2s/AvKxtLD2ukvFJs8kXgyed9GAMgbRAVgpLPGt+
daDkBKESm/8k0Tco0u7XCBuZbz0Pa+VL2OtqaiCoHNiUTVQBlCtnQzRTP2CmrIEx
3CGJ4D9iphUXa8P8wtbWwxtVDeo/jz7ttzjEpHnEmuKwDbTWvZg06MiKcs8mdCII
hXxzJaIoDz5oIh76o71pdBE54PoV5lUlLAVghaFppN7wtNfSnXrHMQLnkwPCsoTf
VBbti12t3nd7W62aYdtkwLwGbk9ZJvOTEch48slkflpCS9Dt6hrYEpd5udSsSSJD
JU7W1un4I1wO2AvbkYGXd8RAL6c7mGfdyKHbmc+oao4anRF2R4i+SuvagwGRyFQr
Pi8/y0c9Jh5o2ZQqS5+EPXsxt8zf4+EmsvBOQK2vPW8Qj8x1E7aG2HaQxF8m7NGK
+0Sx6rqMseCrNlwhLweUnDi0xhPM++nYaPhqYuPCBTO/DKeT9oTj0B3mTN6Do+8A
KvmWzWGeYfth+6lXIq58
=L0MC
-----END PGP SIGNATURE-----

--0FM4RQAc0jwHekq5--
