Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab2IPSlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 14:41:08 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:40791 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab2IPSlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 14:41:05 -0400
Date: Sun, 16 Sep 2012 21:36:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Felipe Balbi <balbi@ti.com>, Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Message-ID: <20120916183620.GA30189@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
 <alpine.DEB.2.00.1209062137000.11516@utopia.booyaka.com>
 <alpine.DEB.2.00.1209112141220.9444@utopia.booyaka.com>
 <20120912062259.GC18563@arwen.pp.htv.fi>
 <alpine.DEB.2.00.1209160117510.23371@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209160117510.23371@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Sep 16, 2012 at 01:22:01AM +0000, Paul Walmsley wrote:
> On Wed, 12 Sep 2012, Felipe Balbi wrote:
>=20
> > On Tue, Sep 11, 2012 at 10:02:48PM +0000, Paul Walmsley wrote:
> >=20
> > > The bad news is that N800 no longer boots -- or the UART dies during=
=20
> > > serial init:
> > >=20
> > > http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020=
323/boot/2420n800/2420n800_log.txt
> > >=20
> > > The problem doesn't seem to affect the 2430SDP.
> > >=20
> > > Could you put together a patch to fix N800?
>=20
> Bisected this down.  It's this one that causes the problem on N800:
>=20
> commit 93220dcc3052182e7156c09655ad1316055564b9
> Author: Felipe Balbi <balbi@ti.com>
> Date:   Thu Sep 6 15:45:27 2012 +0300
>=20
>     serial: omap: set dev->drvdata before enabling pm_runtime
>    =20
>     by the time we call our first pm_runtme_get_sync()
>     after enable pm_runtime, our resume method might
>     be called. To avoid problems, we must make sure
>     that our dev->drvdata is set correctly before
>     our resume method gets called.
>    =20
>     Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
>     Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Interesting. That simply moves platform_set_drvdata() to a saner
location... The only way for this to cause problems is if we're trying
to restore a context which was never saved.

Is there a way to prevent runtime_resume() to be called during probe()
if I know the HW is already enabled ? Maybe with
pm_runtime_set_active() ?

--=20
balbi

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQVhwkAAoJEIaOsuA1yqREVJYP/jqYh5vUZOh5Fq/rEsortJiY
baO1XAXccZhNqo8TyyEqMqMYqA+AtIrj5DROl8ZhBChsxwkKqgvHq/gaAhYMVnq5
r4LboEbQ17EkJQAIwouTVBVsRpm/IP83bNpLl1dLCIVXMjIXUx6QAXFkIae9iwa9
j9yTKzjYp7YFdmAINE6kvkoiDtrzu0qMBmUwqHklTqWGEU6xoZRG2QGXuPYWlVIB
ZTJPTt+osJg1DPrCfZ6ZN0LoJt/snnILlXYZyJQ69B0QOTwLje9rNiYcb9YPseYv
VurWmRa+u5WTmK0tE5vSrY3OKnIFFHJ9OpK98Ip2Pjx4r5fLQSHN/5xDPY8Tt0qu
Twc8GML4vF7JYbJjI9JXm0OgwG1/UVeStYrCd0+RU9p/fZtlmL7Q2T7A/z/Ty3Iv
BzXt7Q7fLsmflj44yPxjO8YNoI9/h6/lJf36eJ3b8k0NqyAYHrvPHDguHRz08ILI
/SjpEVSMs0BWEh7+scOQJYm8fKtlCLgrzJzJeFoB/YT4zJkkSftyjV4mVyy+tK8n
oIqtE5UQMlzKa1JnzWajWgyTt3rpjS5obBEKIeKciFhG0ssJ5L7Xl/E+rXSByq5l
GOI813JXLCYL45ljcxdFDQX8kgwgAJtkFD3aVwjTsyjZzR69rrxQI+1+e6PVCgU/
adIaEqEePasf5nZrLi42
=Fdy5
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
