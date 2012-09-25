Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2IYIgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:36:19 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:60591 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904Ab2IYIgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:36:15 -0400
Date: Tue, 25 Sep 2012 11:31:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Poddar, Sourav" <sourav.poddar@ti.com>, gregkh@linuxfoundation.org,
        khilman@ti.com, paul@pwsan.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, balbi@ti.com, santosh.shilimkar@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
 suspended.
Message-ID: <20120925083118.GI9137@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
 <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
 <20120925083029.GG31374@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVyHzDF4yf4A8jkR"
Content-Disposition: inline
In-Reply-To: <20120925083029.GG31374@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qVyHzDF4yf4A8jkR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 25, 2012 at 09:30:29AM +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 25, 2012 at 01:52:03PM +0530, Poddar, Sourav wrote:
> > Hi Greg,
> >=20
> > Ping on this?
> >=20
> > On Tue, Sep 18, 2012 at 6:10 PM, Sourav Poddar <sourav.poddar@ti.com> w=
rote:
> > > Greg's tty-next is not booting on 2420 based N800. The failure is
> > > observed at serial init itself. The reason might be that n800 tries to
> > > resume even though it is not suspended before.
>=20
> How is this happening?  I think that needs proper investigation - or if
> it's had more investigation, then the results needs to be included in
> the commit description so that everyone can understand the issue here.
>=20
> We should not be resuming a device which hasn't been suspended.  Maybe
> the runtime PM enable sequence is wrong, and that's what should be fixed
> instead? =20
>=20
> This sequence in the probe() function:
>=20
>         pm_runtime_irq_safe(&pdev->dev);
>         pm_runtime_enable(&pdev->dev);
>         pm_runtime_get_sync(&pdev->dev);
>=20
> would enable runtime PM while the s/w state indicates that it's disabled,
> and then that pm_runtime_get_sync() will want to resume the device.  See
> the section "5. Runtime PM Initialization, Device Probing and Removal"
> in Documentation/power/runtime_pm.txt, specifically the second paragraph
> of that section.

that was tested. It worked in pandaboard but didn't work on beagleboard
XM. Sourav tried to start a discussion about that, but it simply died...

In any case, pm_runtime_get_sync() in probe will always call
runtime_resume callback, right ?

--=20
balbi

--qVyHzDF4yf4A8jkR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQYWvWAAoJEIaOsuA1yqREP90P+wa4WZ0LRRV/aEy1Jsd/T1ou
ngprOHFjAGw7wvCRY2btiaF8HW4BtcZG2pnkWbwAxGE4XJ+qjuSsVYxL2sUUlIzq
H1wUBXvVCNwnC/yCnvGbN6zaChnpkJh3/zy8qm/2r6S7lgZn5HaKDQtVKXoVtXot
aBVqYKRx768G94lNDRT/TsJALsH6ODaNsiVOGDZKYlp1zjVEnsJ+POJ/5Ut2Lsd0
skF0wyxWgfprkzNKqWJb3lfYQztW1ghWI2e68wBwuhVVkeNREIykCfK45M+x/PSQ
7CfKAsp4OamRIW1L4gyNnu/0/9PYMk6xuq5heLv+B8HFXBdIz0v+PJz1s+kGsWVE
K+uhvQ2KgD20gOGXXWd5e+XTjPVKC6vh1e6bbHccInBmOBj4r6m/jTCKc/JIsOGc
lqhnUORk+/FLcw+UAHh07FIFtrr4Lo8BP39nBX2r3HPOkrWAVlCe0+ksE03G3Rsv
k1CcFf+b95SuVyuPS3vwt5RJ/g013bqlVq3hZhioxSIIDbxZX31Qv2C33sGzHTR+
qX4l04Fjpnci7jQyONdy4cI9WPX/bdjmSwlfV532usjrw+MEfFK0d2jycZ5A3u+g
sOON92y0j7z7tY/w1LQc7uHxX78h2xLwP+cYzm6mh1C0hmbt5zhLn+vHywPt4Ui/
ftqa3NTTogbKMumSLr6n
=LC7B
-----END PGP SIGNATURE-----

--qVyHzDF4yf4A8jkR--
